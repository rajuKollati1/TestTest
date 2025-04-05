name: Deploy Helm App

on:
  workflow_dispatch:

jobs:
  helm-deploy:
    runs-on: self-hosted

    steps:
      - name: Set KUBECONFIG
        run: echo "KUBECONFIG=/home/k8s-m/.kube/config" >> $GITHUB_ENV

      - name: Install Helm (if not installed)
        run: |
          if ! command -v helm &> /dev/null; then
            curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
          else
            echo "Helm already installed"
          fi

      - name: Add Bitnami repo (optional)
        run: helm repo add bitnami https://charts.bitnami.com/bitnami && helm repo update

      - name: Deploy NGINX using Helm
        run: |
          helm upgrade --install my-nginx bitnami/nginx \
            --set service.type=NodePort \
            --set service.nodePorts.http=30080 \
            --set service.nodePorts.https=30443 \
            --namespace default
