name: Deploy CRD

on:
  workflow_dispatch:  # allows manual trigger only

jobs:
  deploy:
    runs-on: [self-hosted, windows]
    steps:
      - uses: actions/checkout@v3
      - name: Apply CRD to cluster
        run: kubectl apply -f manifests/myapp-crd.yaml
