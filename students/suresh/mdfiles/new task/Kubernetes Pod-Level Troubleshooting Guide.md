# Kubernetes Pod-Level Troubleshooting Guide

This Markdown document provides **step-by-step troubleshooting methods** for resolving **Pod-level issues** in Kubernetes, with real commands and example outputs.

---

## Table of Contents

1. Overview
2. Common Pod States
3. Step-by-Step Troubleshooting Flow
4. Common Pod-Level Issues and Fixes
5. Logs and Events Analysis
6. Live Debugging a Pod
7.  Resource and Node Issues
8. Image and Container Problems
9. Restart and Recovery Steps
10. Interview Questions.

---

## 1. Overview

Pods are the smallest deployable units in Kubernetes. If a Pod fails, the issue could be caused by configuration errors, missing resources, or container runtime issues. Effective troubleshooting requires analyzing the Pod status, events, logs, and node conditions.

---

## 2. Common Pod States

| State                | Description                                                |
| -------------------- | ---------------------------------------------------------- |
| **Pending**          | Pod scheduled but waiting for resources or volume binding. |
| **Running**          | Pod is up and containers are healthy.                      |
| **Succeeded**        | All containers exited successfully.                        |
| **Failed**           | At least one container exited with a non-zero code.        |
| **CrashLoopBackOff** | Container keeps crashing repeatedly.                       |
| **ImagePullBackOff** | Image cannot be pulled from registry.                      |
| **ErrImagePull**     | Registry access or authentication failed.                  |
| **Completed**        | Pod finished execution successfully (for Jobs).            |

---

## 3. Step-by-Step Troubleshooting Flow

### Step 1 — Check Pod status

```bash
kubectl get pods -A
kubectl get pods -n <namespace> -o wide
```

### Step 2 — Describe Pod for events

```bash
kubectl describe pod <pod-name> -n <namespace>
```

Look for **Events** at the bottom (e.g., `FailedScheduling`, `Back-off restarting failed container`).

### Step 3 — Check logs

```bash
kubectl logs <pod-name> -n <namespace>
```

If multiple containers:

```bash
kubectl logs <pod-name> -c <container-name>
```

### Step 4 — Check previous logs (for CrashLoopBackOff)

```bash
kubectl logs <pod-name> -c <container-name> --previous
```

### Step 5 — Execute into container (if running)

```bash
kubectl exec -it <pod-name> -n <namespace> -- /bin/sh
```

### Step 6 — Check Node health

```bash
kubectl get nodes -o wide
kubectl describe node <node-name>
```

---

## 4. Common Pod-Level Issues and Fixes

### 🧩 1. Pod in **Pending** state

**Cause:** No available nodes or PVC not bound.
**Fix:**

```bash
kubectl describe pod <pod-name>
```

* Check `FailedScheduling` events.
* Verify resource requests (CPU/memory) are not too high.
* Ensure storage claim is bound:

  ```bash
  kubectl get pvc
  ```

---

### 🔁 2. Pod in **CrashLoopBackOff**

**Cause:** Application inside container is crashing.
**Fix:**

```bash
kubectl logs <pod-name> --previous
```

Check for error message (e.g., missing config/env var). Example:

```
Error: Missing database connection string
```

➡️ Update Deployment with correct environment variables:

```bash
kubectl edit deployment <deployment-name>
```

Then restart:

```bash
kubectl rollout restart deployment <deployment-name>
```

---

### 🐳 3. **ImagePullBackOff** or **ErrImagePull**

**Cause:** Invalid image name, tag, or missing imagePullSecret.
**Fix:**

* Verify image name:

  ```bash
  kubectl describe pod <pod-name> | grep -i image
  ```
* If private registry:

  ```bash
  kubectl create secret docker-registry regcred \
    --docker-server=<server> \
    --docker-username=<user> \
    --docker-password=<password> \
    --docker-email=<email>
  ```

Add in Pod spec:

```yaml
imagePullSecrets:
- name: regcred
```

Then reapply.

---

### ⚙️ 4. Pod **ContainerCreating** for too long

**Cause:** Image pulling delay or volume mount issue.
**Fix:**

```bash
kubectl describe pod <pod-name>
```

* Check for messages like `MountVolume.SetUp failed` or `Failed to pull image`.
* Validate storage classes and network connectivity to registry.

---

### ⚡ 5. **OOMKilled** (Out of Memory)

**Cause:** Container exceeded memory limit.
**Fix:** Increase memory limit or optimize app:

```yaml
resources:
  requests:
    memory: 256Mi
  limits:
    memory: 512Mi
```

Redeploy and monitor with:

```bash
kubectl top pod <pod-name>
```

---

### 🔒 6. **Permission denied** inside Pod

**Cause:** Wrong file ownership or missing RBAC permissions.
**Fix:**

* Fix file permissions in Dockerfile (`RUN chown -R appuser /app`).
* Add proper ServiceAccount and RoleBinding if Pod needs API access.

---

### 🧱 7. **Pod stuck in Terminating**

**Cause:** Finalizer or volume detach issue.
**Fix:**

```bash
kubectl delete pod <pod-name> --grace-period=0 --force
```

If caused by finalizer:

```bash
kubectl patch pod <pod-name> -p '{"metadata":{"finalizers":[]}}' --type=merge
```

---

### 🔄 8. **Pod restart loop**

**Cause:** Application failing health check.
**Fix:**

```bash
kubectl describe pod <pod-name>
```

Look for `Readiness probe failed` or `Liveness probe failed`. Example fix:

```yaml
livenessProbe:
  httpGet:
    path: /health
    port: 8080
  initialDelaySeconds: 30
  periodSeconds: 10
```

Redeploy.

---

## 5. Logs and Events Analysis

Use `kubectl describe pod` and scroll to **Events** section. Common events:

| Event            | Meaning            | Action                          |
| ---------------- | ------------------ | ------------------------------- |
| FailedScheduling | No node fits pod   | Adjust resource requests        |
| BackOff          | Restart loop       | Fix app or init container issue |
| FailedMount      | Volume mount error | Fix PVC/PV/permissions          |
| FailedPull       | Image not found    | Fix registry credentials        |

---

## 6. Live Debugging a Pod

If Pod fails to start, use **Ephemeral Container**:

```bash
kubectl debug pod/<pod-name> -it --image=busybox --target=<container-name>
```

Useful for exploring file paths, env vars, etc.

---

## 7. Resource and Node Issues

* Check node resource usage:

```bash
kubectl top nodes
kubectl describe node <node-name>
```

* View scheduling errors:

```bash
kubectl get events --sort-by=.metadata.creationTimestamp | grep -i failed
```

---

## 8. Image and Container Problems

* Validate image accessibility:

```bash
docker pull <image-name>
```

* Ensure the container command and args are valid:

```yaml
command: ["/bin/sh", "-c", "echo Hello World"]
```

---

## 9. Restart and Recovery Steps

```bash
kubectl delete pod <pod-name>
# or restart deployment
kubectl rollout restart deployment <deployment-name>
```

Check again:

```bash
kubectl get pods -w
```

---

## 10. Interview Questions

**Q1. How do you troubleshoot a Pod stuck in Pending?**

> Check node resources, taints, and PVC binding using `kubectl describe pod`.

**Q2. How do you debug CrashLoopBackOff?**

> Use `kubectl logs --previous` to see the last container crash logs and fix app/env config.

**Q3. How do you fix ImagePullBackOff?**

> Validate image path, credentials, and registry reachability.

**Q4. How do you handle OOMKilled?**

> Increase memory limits or fix app memory leaks.

**Q5. How do you check Pod events and resource usage?**

> Use `kubectl describe pod` for events and `kubectl top pods` for metrics.

---

✅ **End of File — Kubernetes Pod-Level Troubleshooting Guide**
