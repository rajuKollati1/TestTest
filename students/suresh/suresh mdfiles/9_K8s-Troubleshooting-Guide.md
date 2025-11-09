# Kubernetes Troubleshooting Guide

## Common Issues

### 1. Pod in CrashLoopBackOff
```bash
kubectl describe pod <pod>
kubectl logs <pod>
```
**Fix:** Check container image or environment variables.

### 2. ImagePullBackOff
Check image name or registry authentication.

### 3. Node Not Ready
```bash
kubectl get nodes
kubectl describe node <node>
```

