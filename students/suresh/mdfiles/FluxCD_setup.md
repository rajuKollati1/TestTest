# FluxCD setup for `TestTest-k8s` — step-by-step

This markdown file provides a complete, ready-to-use FluxCD setup for the repository layout you provided. It includes folder structure, example manifests for one app (`app1`), GitHub Actions workflow to build/push the image, Flux `GitRepository` and `Kustomization` manifests, and the exact commands to bootstrap, suspend, resume, and manage Flux Kustomizations.

> **Security note:** never commit personal access tokens to git. Use GitHub Secrets. If you set a token locally for bootstrap, rotate it after use.

---

## 1 — Desired repository structure

```
TestTest-k8s/
├── .github/
│   └── workflows/
├── appbox/
│   ├── app1/
│   │   ├── deployment.yaml
│   │   ├── service.yaml
│   │   └── kustomization.yaml
│   ├── app2/   # optional additional apps
│   └── kustomization.yaml
├── clusters/
│   └── my-lab/
│       ├── flux-system/           # optional place to keep flux manifests
│       └── kustomization.yaml     # cluster-level kustomization watched by Flux
├── README.md
```

Create these folders locally before adding files:

```bash
mkdir -p TestTest-k8s/{.github/workflows,appbox/app1,clusters/my-lab/flux-system}
cd TestTest-k8s
```

---

## 2 — Application manifests (`appbox/app1`)

### `appbox/app1/deployment.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app1
  labels:
    app: app1
spec:
  replicas: 1
  selector:
    matchLabels:
      app: app1
  template:
    metadata:
      labels:
        app: app1
    spec:
      containers:
        - name: app1
          image: ghcr.io/<GITHUB_OWNER>/app1:latest   # update <GITHUB_OWNER>
          ports:
            - containerPort: 80
```

### `appbox/app1/service.yaml`

```yaml
apiVersion: v1
kind: Service
metadata:
  name: app1
spec:
  selector:
    app: app1
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: ClusterIP
```

### `appbox/app1/kustomization.yaml`

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - deployment.yaml
  - service.yaml
```

### `appbox/kustomization.yaml`

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - ./app1
```

---

## 3 — Cluster-level Flux Kustomization (`clusters/my-lab/kustomization.yaml`)

```yaml
apiVersion: kustomize.toolkit.fluxcd.io/v1beta2
kind: Kustomization
metadata:
  name: appbox-kustomization
  namespace: flux-system
spec:
  interval: 1m0s
  path: ./appbox
  prune: true
  sourceRef:
    kind: GitRepository
    name: flux-system
  targetNamespace: default
```

---

## 4 — GitRepository manifest (`clusters/my-lab/flux-system/gitrepository.yaml`)

```yaml
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: GitRepository
metadata:
  name: flux-system
  namespace: flux-system
spec:
  interval: 1m0s
  url: https://github.com/<ownerofgithub>/TestTest-k8s.git
  ref:
    branch: main
```

---

## 5 — GitHub Actions workflow (`.github/workflows/main_dockerdeployment.yaml`)

```yaml
name: Build and push app1 image

on:
  push:
    paths:
      - 'appbox/app1/**'
      - '.github/workflows/**'

jobs:
  build:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write

    steps:
      - uses: actions/checkout@v4

      - name: Login to GitHub Container Registry
        uses: docker/login-action@v2
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.CR_PAT }}

      - name: Build and push Docker image
        uses: docker/build-push-action@v5
        with:
          context: ./appbox/app1
          push: true
          tags: ghcr.io/${{ github.repository_owner }}/app1:latest
```

Set the `CR_PAT` secret in GitHub repository settings.

---

## 6 — Bootstrap Flux to GitHub

```powershell
$env:GITHUB_TOKEN = "<YOUR_GITHUB_TOKEN>"

flux bootstrap github `
  --owner=<ownerofgithub> `
  --repository=TestTest-k8s `
  --branch=main `
  --path=clusters/my-lab `
  --personal `
  --token-auth
```

---

## 7 — Suspend and Resume Flux Kustomizations

Sometimes you need to pause reconciliation to make manual changes.

### Suspend a Kustomization

```bash
flux suspend kustomization appbox-kustomization -n flux-system
```

### Resume a Kustomization

```bash
flux resume kustomization appbox-kustomization -n flux-system
```

### Suspend all Kustomizations in flux-system

```bash
flux suspend kustomization --all -n flux-system
```

### Resume all Kustomizations in flux-system

```bash
flux resume kustomization --all -n flux-system
```

### Suspend or resume the entire flux-system (GitRepository)

```bash
flux suspend source git flux-system -n flux-system
flux resume source git flux-system -n flux-system
```

---

## 8 — Verify Flux state

```bash
kubectl get pods -n flux-system
kubectl get gitrepositories -n flux-system
kubectl get kustomizations -n flux-system
kubectl describe kustomization appbox-kustomization -n flux-system
```

---

## 9 — Troubleshooting tips

* Check if `path:` matches exactly.
* Use logs:

  ```bash
  kubectl logs -n flux-system deployment/source-controller
  kubectl logs -n flux-system deployment/kustomize-controller
  ```
* Verify image accessibility.

---

## 10 — Next steps

* Add `ImageRepository`, `ImagePolicy`, and `ImageUpdateAutomation` for automated image updates.
* Create separate environments under `clusters/` for staging or production.

---

✅ **You now have a complete FluxCD setup for TestTest-k8s, with
