# FluxCD bootstrap — create GitHub classic token + PowerShell commands (step-by-step)

This markdown explains how to **create a GitHub Classic Personal Access Token (PAT)**, run the `flux bootstrap github` command from an **Administrator PowerShell**, and includes the Flux **suspend/resume** and verification commands. It’s tailored for the `TestTest-k8s` repository layout and the bootstrap command you provided.

> **Security note:** Classic PATs are powerful. Create a token with the minimum required scopes, store it only in GitHub Secrets or a local session, and **rotate** it after use. Never commit tokens to your repo.

---

## 1 — Required scopes for the PAT (classic)

When creating a classic PAT via GitHub web UI, grant the following scopes at minimum when using GHCR + repo access:

* `repo` (Full control of private repositories) — required if repo is private or to let Flux read repo contents.
* `workflow` (read & write) — if you want bootstrap or workflows to create Actions resources (optional).
* `write:packages` (or `packages:write`) — to push images to GitHub Container Registry (GHCR) from GitHub Actions.
* `read:packages` — to pull images if needed.

If you *only* need Flux to read the repo and you use a separate PAT for GHCR, you can reduce scopes, but the above are common.

---

## 2 — Create a Classic PAT (GitHub web UI)

1. Sign in to GitHub and open: **Settings → Developer settings → Personal access tokens → Tokens (classic)**.
2. Click **Generate new token → Generate new token (classic)**.
3. Give it a clear name (e.g., `flux-bootstrap-<date>`).
4. Select the scopes listed above (`repo`, `workflow`, `write:packages`, `read:packages`).
5. Click **Generate token** and copy the token immediately — you won’t be able to view it again.
6. Store it in a secure place (or add to GitHub Secrets and delete local copies). Rotate after use.

---

## 3 — Add GHCR PAT as GitHub Secret (for Actions) — `CR_PAT`

If you will use GitHub Actions to build/push images to GHCR, add the PAT as a repository secret:

* Repo → Settings → Secrets and variables → Actions → New repository secret

  * Name: `CR_PAT`
  * Value: `<your-classic-pat-with-packages-scope>`

---

## 4 — Run PowerShell as Administrator and set the token for the session

> You only need to set the environment variable for the current PowerShell session. Do **not** store the token in files that get committed.

1. Open **PowerShell (Admin)**.
2. Set the token for the session (replace with your token):

```powershell
# set token for this PowerShell session (do not commit this)
$env:GITHUB_TOKEN = "ghp_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
```

3. Verify it’s set (optional):

```powershell
echo $env:GITHUB_TOKEN  # will print token in console — avoid doing this in shared terminals
```

---

## 5 — Ensure prerequisites are installed

* `kubectl` configured to talk to your Kubernetes cluster.
* `flux` CLI installed and on PATH.
* `git` installed and authenticated (or you’ll rely on flux using the token).

Install Flux CLI (Windows example):

```powershell
# using winget (Windows)\winget install GitHub.fluxcd.flux
# or follow https://fluxcd.io/docs/installation/
```

---

## 6 — Bootstrap Flux with your repository (PowerShell command)

Run this command from the machine with `kubectl` access to the target cluster (PowerShell multiline format):

```powershell
flux bootstrap github `
  --owner=<ownerofgithub> `
  --repository=TestTest-k8s `
  --branch=main `
  --path=clusters/my-lab `
  --personal `
  --token-auth
```

**What this does:**

* Installs Flux controllers into your Kubernetes cluster (`flux-system` namespace).
* Creates a `GitRepository` resource in `flux-system` pointing to your repo.
* Creates an initial Kustomization that watches `clusters/my-lab`.

**If the bootstrap creates resources in the repo:** push them to `main` or accept the commit created by the bootstrap.

---

## 7 — Add or verify `clusters/my-lab/kustomization.yaml`

Make sure you have this file in your repo so Flux knows which path to reconcile. Example:

```yaml
apiVersion: kustomize.toolkit.fluxcd.io/v1beta2
kind: Kustomization
metadata:
  name: appbox-kustomization
  namespace: flux-system
spec:
  interval: 1m0s
  path: ./apps/employeapp
  prune: true
  sourceRef:
    kind: GitRepository
    name: flux-system
  targetNamespace: default
```

Commit & push this file if you created/updated it locally:

```bash
git add clusters/my-lab/kustomization.yaml
git commit -m "Add flux kustomization for appbox"
git push origin main
```

---

## 8 — Suspend & resume commands (for daily operations)

### Suspend a single Kustomization

```bash
flux suspend kustomization appbox-kustomization -n flux-system
```

### Resume a single Kustomization

```bash
flux resume kustomization appbox-kustomization -n flux-system
```

### Suspend all Kustomizations in `flux-system`

```bash
flux suspend kustomization --all -n flux-system
```

### Resume all Kustomizations in `flux-system`

```bash
flux resume kustomization --all -n flux-system
```

### Suspend/resume the Git `source` (stop Flux from reading the repo)

```bash
flux suspend source git flux-system -n flux-system
flux resume source git flux-system -n flux-system
```

---

## 9 — Verify Flux state & troubleshoot

```bash
# check Flux controllers
kubectl get pods -n flux-system

# check GitRepository and Kustomization resources
kubectl get gitrepositories -n flux-system
kubectl get kustomizations -n flux-system

# inspect last reconciliation and status
kubectl describe kustomization appbox-kustomization -n flux-system

# controller logs
kubectl logs -n flux-system deployment/source-controller
kubectl logs -n flux-system deployment/kustomize-controller
```

Common issues:

* **Path not found:** confirm `path:` exactly matches repo layout.
* **Image pull errors:** ensure image exists and credentials (imagePullSecrets or public image) are correct.
* **Auth problems:** check `GitRepository` status for authentication errors.

---

## 10 — Clean-up & rotate tokens

* After bootstrap, if you used a personal token locally, unset it from your PowerShell session:

```powershell
Remove-Item Env:\GITHUB_TOKEN
```

* If the token was only for bootstrap, revoke and rotate it in GitHub (Settings → Developer settings → Personal access tokens).

---

## 11 — Example quick workflow (summary)

1. Create classic PAT with required scopes and copy it.
2. Add `CR_PAT` secret to GitHub repo (for Actions).
3. Open PowerShell (Admin) and run:

```powershell
$env:GITHUB_TOKEN = "<YOUR_TOKEN>"
flux bootstrap github --owner=<ownerofgithub> --repository=TestTest-k8s --branch=main --path=clusters/my-lab --personal --token-auth
```

4. Push `clusters/my-lab/kustomization.yaml` if not already present.
5. Verify with `kubectl` and `flux` CLI commands.
6. Remove the local token and rotate if needed.

---

If you want, I can now:

* generate a ready-to-commit `clusters/my-lab/kustomization.yaml` and `flux-system/gitrepository.yaml` with your GitHub owner filled in, or
* create an automated `ImageRepository` & `ImageUpdateAutomation` for the app image.

Tell me which you prefer and I’ll add it to the repo doc.
