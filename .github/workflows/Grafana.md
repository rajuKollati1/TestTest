name: Install Grafana using Helm

on:
  push:
    branches:
      - main  # Trigger this workflow on push to main branch

jobs:
  install-grafana:
    runs-on: self-hosted  # Ensure the workflow uses the self-hosted runner

    steps:
    - name: Check out repository
      uses: actions/checkout@v2

    - name: Add Grafana Helm repository
      run: |
        helm repo add grafana https://grafana.github.io/helm-charts
        helm repo update

    - name: Install Grafana using Helm
      run: |
        helm install grafana grafana/grafana --namespace monitoring --create-namespace
