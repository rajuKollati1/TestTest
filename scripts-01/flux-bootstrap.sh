di#!/bin/bash
# ============================================================
# FluxCD Bootstrap Script for GitHub (Git Bash / Linux Compatible)
# ============================================================

# 🧩 User variables — change these before running
export GITHUB_TOKEN=
GITHUB_USER="rajuKollati1"
GITHUB_REPO="TestTest"
GITHUB_BRANCH="main"
FLUX_PATH="clusters/my-lab"

# ============================================================
# 🧰 Prerequisites check
# ============================================================
echo "🔍 Checking prerequisites..."

if ! command -v kubectl &> /dev/null; then
  echo "❌ kubectl not found. Please install kubectl before running this script."
  exit 1
fi

if ! command -v flux &> /dev/null; then
  echo "❌ flux CLI not found. Installing Flux CLI..."
  curl -s https://fluxcd.io/install.sh | bash
fi

echo "✅ Prerequisites verified."

# ============================================================
# 🚀 Bootstrap FluxCD
# ============================================================
echo "🚀 Bootstrapping FluxCD..."

flux bootstrap github \
  --owner=$GITHUB_USER \
  --repository=$GITHUB_REPO \
  --branch=$GITHUB_BRANCH \
  --path=$FLUX_PATH \
  --personal \
  --components=source-controller,kustomize-controller,helm-controller

# ============================================================
# ✅ Verify Flux installation
# ============================================================
echo "🔍 Verifying Flux installation..."
flux get all

echo "✅ Flux bootstrap completed successfully!"
echo "📂 GitHub Repo: https://github.com/$GITHUB_USER/$GITHUB_REPO"
echo "🗂️ Path Synced: $FLUX_PATH"

 
