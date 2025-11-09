# GitHub Actions — Docker Build & Push Workflow

## Folder Structure
```
apps/appname/index.html
Dockerfile
k8s/application.yaml
.github/workflows/main_dockerdeployment.yaml
```

## Workflow Example
```yaml
name: Docker Build & Push

on:
  push:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Login to Docker Hub
        run: echo "${{ secrets.DOCKER_PASSWORD }}" | docker login -u "${{ secrets.DOCKER_USERNAME }}" --password-stdin

      - name: Build Docker Image
        run: docker build -t ${{ secrets.DOCKER_USERNAME }}/myapp:latest .

      - name: Push Docker Image
        run: docker push ${{ secrets.DOCKER_USERNAME }}/myapp:latest
```

## Setup Secrets
Go to **GitHub → Repo → Settings → Secrets → Actions**  
Add:  
- `DOCKER_USERNAME`  
- `DOCKER_PASSWORD`  

