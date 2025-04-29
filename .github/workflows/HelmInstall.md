name: Deploy Grafana on Windows Runner

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: [self-hosted, windows]

    steps:
    - name: Checkout repository
      uses: actions/checkout@v3

    - name: Download and install Helm
      shell: powershell
      run: |
        $helmVersion = "v3.14.0"
        Invoke-WebRequest -Uri "https://get.helm.sh/helm-$helmVersion-windows-amd64.zip" -OutFile "helm.zip"
        Expand-Archive -Path "helm.zip" -DestinationPath ".\helm"
        Copy-Item ".\helm\windows-amd64\helm.exe" -Destination "C:\Program Files\helm\helm.exe" -Force
        $env:Path += ";C:\Program Files\helm"


