# Kubernetes Kubectl Commands (Professional Reference)

## Overview
This document provides essential `kubectl` commands for managing Kubernetes clusters efficiently. It is designed for production use, troubleshooting, and interviews.

### Cluster & Context Management
```bash
kubectl config view                # View configuration
kubectl cluster-info               # Display cluster info
kubectl get namespaces             # List namespaces
kubectl config use-context <ctx>   # Switch context
```
> 💡 Use `kubectl config get-contexts` to list available contexts.

### Pods
```bash
kubectl get pods                   # List all pods
kubectl describe pod <pod>         # Describe pod details
kubectl logs <pod>                 # View pod logs
kubectl exec -it <pod> -- bash     # Access pod shell
```
Example:
```bash
kubectl run nginx --image=nginx --port=80
```

### Deployments
```bash
kubectl get deployments
kubectl apply -f deployment.yaml
kubectl rollout status deployment/<name>
kubectl rollout undo deployment/<name>
```
Example deployment file:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
```

### Services
```bash
kubectl expose deployment nginx-deployment --type=NodePort --port=80
kubectl get svc
```
Example output:
```
NAME              TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
nginx-deployment  NodePort    10.96.21.32    <none>        80:30007/TCP   1m
```
