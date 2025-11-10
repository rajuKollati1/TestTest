# 🧩 Kubernetes Pod-Level Troubleshooting Guide

## 🧠 Overview

Pod-level issues are among the most common problems in Kubernetes. These issues occur during the Pod lifecycle — from scheduling, pulling images, mounting volumes, to running containers.

Below are the **most frequent Pod-level issues**, their **root causes**, **diagnostic commands**, and **fixes**.

---

## ⚙️ 1. CrashLoopBackOff

**Symptoms:**

* Pod keeps restarting repeatedly.
* `kubectl get pods` shows `CrashLoopBackOff`.

**Root Causes:**

* Application crash due to configuration error.
* Missing dependency (DB, API, etc.).
* Wrong command or args in container spec.

**Fix:**

```bash
kubectl logs <pod-name> -n <namespace>
```

* Check application logs.
* Verify environment variables and ConfigMaps.
* Update command/args in the Pod spec.

---

## 📦 2. ImagePullBackOff / ErrImagePull

**Symptoms:**

* Pod stuck at `ImagePullBackOff` or `ErrImagePull`.

**Root Causes:**

* Invalid image name or tag.
* Private image without credentials.
* DockerHub rate limit exceeded.

**Fix:**

```bash
kubectl describe pod <pod-name>
```

* Verify image name and registry.
* If private, create a secret:

```bash
kubectl create secret docker-registry regcred \
  --docker-server=<registry> \
  --docker-username=<user> \
  --docker-password=<pass> \
  --docker-email=<email>
```

* Reference it in your Pod spec.

---

## 🧱 3. Pending Pods

**Symptoms:**

* Pod stays in `Pending` state.

**Root Causes:**

* Not enough cluster resources.
* No matching node selector or taint tolerations.
* PVC not bound or StorageClass missing.

**Fix:**

```bash
kubectl describe pod <pod-name>
```

* Check for `Insufficient CPU/Memory`.
* Check PVC binding:

```bash
kubectl get pvc
```

* Scale nodes or adjust resource requests.

---

## 🔒 4. RBAC (Role-Based Access Control) Errors

**Symptoms:**

* Pod logs show errors like `User "system:serviceaccount:default:default" cannot get resource...`
* Controller or app fails due to insufficient permissions.

**Root Causes:**

* Missing Role/ClusterRole.
* ServiceAccount not bound correctly.

**Fix:**

* Check ServiceAccount and RoleBinding:

```bash
kubectl get sa
kubectl get rolebinding,clusterrolebinding
```

* Example fix:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: app-rbac
  namespace: default
subjects:
- kind: ServiceAccount
  name: my-app-sa
  namespace: default
roleRef:
  kind: Role
  name: app-role
  apiGroup: rbac.authorization.k8s.io
```

* Reapply manifests and restart the Pod.

---

## ❤️ 5. Liveness Probe Failures

**Symptoms:**

* Pod restarts frequently due to failed health checks.

**Root Causes:**

* Incorrect `livenessProbe` configuration.
* Probe path or port unavailable.

**Fix:**

* Describe Pod for probe failure messages:

```bash
kubectl describe pod <pod-name>
```

* Ensure endpoint is correct.
* Example corrected probe:

```yaml
livenessProbe:
  httpGet:
    path: /healthz
    port: 8080
  initialDelaySeconds: 10
  periodSeconds: 5
```

---

## 💙 6. Readiness Probe Failures

**Symptoms:**

* Pod doesn’t receive traffic even though it’s running.

**Root Causes:**

* Application not ready when probe checks.
* Wrong path or port in readiness probe.

**Fix:**

* Increase delay or verify endpoint:

```yaml
readinessProbe:
  httpGet:
    path: /ready
    port: 8080
  initialDelaySeconds: 15
  periodSeconds: 10
```

* Validate readiness endpoint manually using `curl` or `kubectl exec`.

---

## 🧠 Summary Table

| Issue             | Root Cause              | Fix                        |
| ----------------- | ----------------------- | -------------------------- |
| CrashLoopBackOff  | App crash, bad config   | Check logs, fix env vars   |
| ImagePullBackOff  | Image not found/private | Fix image name, add secret |
| Pending           | Resource shortage       | Check nodes, PVCs          |
| RBAC              | Permission denied       | Fix Role/ServiceAccount    |
| Liveness Failure  | Wrong path/port         | Adjust probe config        |
| Readiness Failure | App not ready           | Tune readiness probe       |

---

## 🧩 Troubleshooting Commands Summary

```bash
kubectl get pods -A
kubectl describe pod <pod-name>
kubectl logs <pod-name> -n <namespace>
kubectl exec -it <pod-name> -- /bin/sh
kubectl get events --sort-by='.metadata.creationTimestamp'
```

---

## 🗣️ Interview Tip

> Q: How do you troubleshoot a pod stuck in CrashLoopBackOff?
>
> ✅ A: I check logs using `kubectl logs <pod>`, review container startup commands, inspect ConfigMaps and Secrets, and confirm that dependencies like DB or APIs are reachable.

---

✅ **End of Pod-Level Troubleshooting Guide**
