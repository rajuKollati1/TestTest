
# 🔁 Complete FluxCD Setup Guide (Local & Cluster) – By Raju Kollati

## 🧱 Prerequisites

- GitHub account (`rajuKollati1`)
- Kubernetes cluster running (`mycluster-001`)
- Git installed on your Windows machine
- Git Bash or PowerShell terminal

---

## 1️⃣ Install Flux CLI (Local Machine)

### 🟢 On Windows (Git Bash or PowerShell)

```
choco install flux
```

OR via curl:

```
curl -s https://fluxcd.io/install.sh | sudo bash
```

### ✅ Verify Installation

```
flux --version
```

---

## 2️⃣ Install Flux Components in Kubernetes

> ⚠️ Don't bootstrap yet — just install required controllers.

```
flux install
```

This installs:
- `source-controller`
- `kustomize-controller`
- `helm-controller`
- `notification-controller`

You can verify with:

```
kubectl get pods -n flux-system
```

---

## 3️⃣ Create GitHub Personal Access Token (If Using HTTPS Method)

> Optional if you're switching to SSH later.

1. Go to: https://github.com/settings/tokens
2. Generate a token with the following **scopes**:
   - `repo`
   - `admin:public_key`
   - `workflow`

---

## 4️⃣ Generate SSH Key (if not already present)

```
ssh-keygen -t ed25519 -C "your_email@example.com"
```

When asked where to save:
```
C:\Users\YourName\.ssh\id_ed25519
```

No passphrase needed.

---

## 5️⃣ Add SSH Key to GitHub

### 🔐 Upload SSH Key to GitHub

1. Copy the public key:

    ```
    cat ~/.ssh/id_ed25519.pub
    ```

2. Go to:
    - GitHub → **Settings** → **SSH and GPG Keys** → **New SSH key**
    - Title: `fluxcd-key`
    - Key: Paste your `id_ed25519.pub`
    - Access: Full (read/write)

---

## 6️⃣ Start SSH Agent on Windows

In PowerShell **as administrator**:

```
Get-Service ssh-agent | Set-Service -StartupType Automatic
Start-Service ssh-agent
```

Then add your key:

```
ssh-add ~/.ssh/id_ed25519
```

---

## 7️⃣ Test SSH Access to GitHub

```
ssh -T git@github.com
```

Expected:
```
Hi rajuKollati1! You've successfully authenticated...
```

---

## 8️⃣ Flux Bootstrap with SSH

### Create a new repo or use existing (e.g., `TestTest`)

Then run:

```
flux bootstrap git \
  --url=ssh://git@github.com/rajuKollati1/TestTest.git \
  --branch=main \
  --path=clusters/my-cluster \
  --components-extra=image-reflector-controller,image-automation-controller \
  --token-auth=false
```

If successful:
- Manifests pushed to `TestTest` repo
- Flux will reconcile from `clusters/my-cluster`

---

## 9️⃣ Confirm Flux is Working

```
kubectl get pods -n flux-system
```

You should see:

```
helm-controller                     Running
kustomize-controller                Running
notification-controller            Running
source-controller                  Running
image-reflector-controller         Running
image-automation-controller        Running
```

---

## 📂 Repo Structure (GitOps)

Your GitHub repo will have:

```
TestTest/
└── clusters/
    └── my-cluster/
        ├── gotk-components.yaml
        ├── gotk-sync.yaml
        └── kustomization.yaml
```

---

## ✅ You're Done!

Now you're ready to manage Kubernetes applications via Git using FluxCD GitOps!
