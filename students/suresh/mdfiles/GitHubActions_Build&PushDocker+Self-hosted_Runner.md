# GitHub Actions — Build & Push Docker image, deploy to Kubernetes, and run self‑hosted Actions runner (step-by-step)

This guide walks you through: **folder structure**, sample **Dockerfile**, a Kubernetes manifest, a GitHub Actions workflow (`.github/workflows/main_dockerdeployment.yaml`) that builds and pushes a Docker image to Docker Hub, and how to run a self‑hosted GitHub Actions runner on Windows (Docker Desktop) using PowerShell Admin and `./run.cmd`.

---

## Folder structure (example)

```
repo-root/
├─ apps/
│  └─ appname/
│     ├─ index.html
│     └─ Dockerfile
├─ k8s/
│  └─ application.yaml
└─ .github/
   └─ workflows/
      └─ main_dockerdeployment.yaml
```

Replace `appname` with your app's name.

---

## 1) Sample `apps/appname/index.html`

```html
<!doctype html>
<html>
  <head><meta charset="utf-8"><title>App</title></head>
  <body>
    <h1>Hello from appname!</h1>
  </body>
</html>
```

---

## 2) Sample `apps/appname/Dockerfile`

A small nginx static site Dockerfile (works for a simple `index.html`):

```dockerfile
# simple static site image
FROM nginx:stable-alpine
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

If your app uses Node, replace accordingly.

---

## 3) Sample Kubernetes manifest `k8s/application.yaml`

This manifest uses an image placeholder `{{IMAGE}}` that the workflow will replace with the pushed image tag.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: appname-deployment
  labels:
    app: appname
spec:
  replicas: 1
  selector:
    matchLabels:
      app: appname
  template:
    metadata:
      labels:
        app: appname
    spec:
      containers:
        - name: appname
          image: "{{IMAGE}}"   # <-- replaced during CI
          ports:
            - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: appname-service
spec:
  selector:
    app: appname
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: ClusterIP
```

---

## 4) GitHub repository: add secrets (in Settings → Secrets → Actions)

Create these repository secrets:

* `DOCKERHUB_USERNAME` → your Docker Hub username
* `DOCKERHUB_PASSWORD` → Docker Hub password or access token (recommended: use a token)
* `KUBE_CONFIG_DATA` → base64-encoded kubeconfig for the cluster (if you want the workflow to deploy to your k8s). Create with:

```bash
# on your machine which has kubeconfig configured for target cluster
cat ~/.kube/config | base64 -w0
# copy output and paste to GitHub secret KUBE_CONFIG_DATA
```

**Security note:** Don't commit kubeconfig. Use secrets.

---

## 5) Workflow file `.github/workflows/main_dockerdeployment.yaml`

This workflow:

1. Runs on `push` to `main` (change as needed)
2. Builds the Docker image from `apps/appname` and pushes to Docker Hub
3. Replaces `{{IMAGE}}` placeholder in `k8s/application.yaml` with the pushed image
4. Uses `kubectl` to apply the manifest (requires `KUBE_CONFIG_DATA` secret)

```yaml
name: Build, Push Docker and Deploy to K8s

on:
  push:
    branches: [ main ]

env:
  APP_NAME: appname
  IMAGE_TAG: ${{ github.sha }}
  IMAGE: ${{ secrets.DOCKERHUB_USERNAME }}/${{ env.APP_NAME }}:${{ env.IMAGE_TAG }}

jobs:
  build-and-push:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Set up QEMU (for multi-platform, optional)
        uses: docker/setup-qemu-action@v2

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v2

      - name: Log in to Docker Hub
        uses: docker/login-action@v2
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_PASSWORD }}

      - name: Build and push Docker image
        uses: docker/build-push-action@v4
        with:
          context: ./apps/${{ env.APP_NAME }}
          push: true
          tags: ${{ env.IMAGE }}

      - name: Prepare k8s manifest (replace placeholder)
        run: |
          mkdir -p k8s-out
          IMAGE=${{ env.IMAGE }}
          sed "s|{{IMAGE}}|${IMAGE}|g" k8s/application.yaml > k8s-out/application.yaml

      - name: Setup kubectl
        uses: azure/setup-kubectl@v3
        with:
          version: 'latest'

      - name: Configure kubeconfig
        if: ${{ secrets.KUBE_CONFIG_DATA != '' }}
        run: |
          echo "$KUBE_CONFIG_DATA" | base64 -d > kubeconfig
          export KUBECONFIG=$PWD/kubeconfig
        env:
          KUBE_CONFIG_DATA: ${{ secrets.KUBE_CONFIG_DATA }}

      - name: Apply k8s manifest
        if: ${{ secrets.KUBE_CONFIG_DATA != '' }}
        run: |
          export KUBECONFIG=$PWD/kubeconfig
          kubectl apply -f k8s-out/application.yaml

  # end job
```

**Notes:**

* `IMAGE_TAG` uses the commit SHA to create unique tags. You can use `github.run_number` or semantic tags instead.
* If you don't want to deploy from Actions, remove the kubectl steps.

---

## 6) Push workflow and test

1. Commit and push the repo to GitHub.
2. The workflow will run on `push` to `main`.
3. Check the Actions tab → select the workflow run → view logs.
4. On success, image will be available at `docker.io/<DOCKERHUB_USERNAME>/appname:<SHA>`.

---

## 7) Running a self‑hosted Actions runner on Windows (PowerShell, Admin) — quick steps

If you want to run your GitHub Actions on a self-hosted runner (e.g., your laptop/VM with Docker Desktop), follow these steps.

**A. Create a runner on GitHub**

1. Go to your repo → Settings → Actions → Runners → Add runner → Choose `Windows`.
2. GitHub provides a set of commands to download and configure the runner. Copy them OR follow the steps below.

**B. Download and configure runner (PowerShell Admin)**

Open PowerShell **as Administrator** and run:

```powershell
# make a folder
mkdir actions-runner
cd actions-runner

# Download the runner (example for x64; check latest runner version on GitHub UI when you add a runner)
$runnerVersion = '2.306.0'  # example; use the version from GitHub UI
$zipUrl = "https://github.com/actions/runner/releases/download/v$runnerVersion/actions-runner-win-x64-$runnerVersion.zip"
Invoke-WebRequest -Uri $zipUrl -OutFile actions-runner.zip

# Unzip
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory("actions-runner.zip", "$PWD")

# Configure the runner (you will get a token from GitHub when adding a new runner in the UI)
# Example (replace <TOKEN> and <REPO_URL>):
# .\config.cmd --url https://github.com/<OWNER>/<REPO> --token <TOKEN>

# After successful configure, run the runner
# .\run.cmd
```

**C. Start the runner**

* From the same PowerShell session run:

```powershell
.\run.cmd
```

* The runner will connect to GitHub and poll for jobs. When your workflow is triggered and targeted to this runner (or uses `runs-on: self-hosted` labels that match), the job will run on this machine.

**D. Common notes**

* The runner must stay running. To run it as a Windows service, follow GitHub docs for `svc.sh` / `svc install` for Linux or the Windows service instructions shown in the runner setup step in GitHub UI.
* Make sure Docker Desktop is running if your runner builds Docker images locally (or ensure the runner has Docker Engine access).

---

## 8) Alternative: run the job on the runner (use `runs-on: self-hosted`)

If you want the build-and-push job to run on your self-hosted runner, change the job top line to:

```yaml
jobs:
  build-and-push:
    runs-on: [self-hosted, windows]
```

Keep in mind the runner OS (windows vs linux) affects which actions run correctly. The `docker/build-push-action` works on both if Docker engine is available.

---

## 9) Troubleshooting tips

* **Docker login fails**: check `DOCKERHUB_USERNAME` and `DOCKERHUB_PASSWORD` secrets and quotas on Docker Hub.
* **kubectl errors**: verify `KUBE_CONFIG_DATA` is valid base64 and belongs to a kubeconfig with cluster access.
* **Self-hosted runner shows offline**: check network/firewall, ensure `run.cmd` is running, and the runner token was configured correctly.
* **Permission denied on run.cmd**: run PowerShell as Administrator.

---

## 10) Security & best practices

* Use Docker Hub access tokens instead of your password.
* Narrow down the permissions for the token.
* Keep kubeconfig access minimal (create a ServiceAccount with limited rights if possible).
* Use tags (not `latest`) for images in production.

---

If you want, I can:

* Produce the exact `main_dockerdeployment.yaml` filled with your DockerHub username and a tag strategy you prefer.
* Show how to configure the runner as a Windows service.
* Provide a version that uses GitHub Packages (ghcr.io) instead of Docker Hub.

Would you like me to fill in your Docker Hub username now and generate a ready-to-copy workflow file?
