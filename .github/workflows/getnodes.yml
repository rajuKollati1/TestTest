name: Kubernetes Nodes Status

on:
  workflow_dispatch:

jobs:
  get-nodes:
    runs-on: self-hosted

    steps:
      - name: Print current user
        run: whoami

      - name: Run 'kubectl get nodes'
        run: |
          echo "Running kubectl get nodes..."
          #export KUBECONFIG=/etc/kubernetes/admin.conf
          kubectl get nodes -o wide
