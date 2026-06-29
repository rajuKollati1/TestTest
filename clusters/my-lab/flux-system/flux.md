$env:GITHUB_TOKEN=""
$env:GITHUB_USER="rajukollati1"


# On Linux/macOS
export GITHUB_TOKEN=
export GITHUB_USER=rajukollati1

flux bootstrap github \
  --owner=rajukollati1 \
  --repository=TestTest \
  --branch=main \
  --path=clusters/my-lab-env \
  --personal


  ## uninstall flux if existing
  flux uninstall --namespace=flux-system