# Kubernetes Common Issues and Error Fixes

This document lists **frequent Kubernetes issues**, **root causes**, and **solutions** — useful for troubleshooting and interview preparation.

---

## Table of Contents

1. Pod issues
2. Node issues
3. Service & Networking issues
4. Deployment issues
5. PersistentVolume & PVC issues
6. ConfigMap & Secret issues
7. Helm & Manifest errors
8. ImagePull & Registry errors
9. RBAC & Permission issues
10. General debugging commands

---

## 1. Pod Issues

### ❌ Pod stuck in `Pending`

**Cause:**

* No available nodes with matching resources (CPU/memory).
* No matching PV for PVC.
* Node taints prevent scheduling.

**Fix:**

```bash
kubectl describe pod <pod-name>
```

Check Events section → fix resource requests or tolerations.

### ❌ Pod stuck in `CrashLoopBackOff`

**Cause:** Application crash, bad configuration, or missing dependency.

**Fix:**

```bash
kubectl logs <pod-name> --previous
kubectl describe pod <pod-name>
```

Check logs for errors → fix environment variables, config, or entrypoint.

### ❌ Pod stuck in `ImagePullBackOff` or `ErrImagePull`

**Cause:** Image not found or no registry credentials.

**Fix:**

* Check image name/tag.
* If private repo:

  ```bash
  kubectl create secret docker-registry regcred --docker-server=<server> --docker-username=<user> --docker-password=<pass> --docker-email=<email>
  ```

  Then reference it under `imagePullSecrets` in Pod spec.

---

## 2. Node Issues

### ❌ Node `NotReady`

**Cause:**

* Kubelet stopped, network problem, or disk full.

**Fix:**

```bash
kubectl describe node <node>
systemctl status kubelet
journalctl -u kubelet -xe
```

Ensure network connectivity to control plane and enough disk space.

### ❌ Pods not scheduled on specific node

**Cause:** Taints, unsatisfied affinity, or insufficient resources.

**Fix:**

```bash
kubectl describe node <node>
kubectl get pods -o wide
```

Remove taints if needed:

```bash
kubectl taint nodes <node> key=value:NoSchedule-
```

---

## 3. Service & Networking Issues

### ❌ Service not reachable from browser or cluster

**Cause:**

* Wrong Service type or port.
* NetworkPolicy blocking traffic.

**Fix:**

```bash
kubectl get svc
kubectl describe svc <service>
```

Check port mapping and service type (`ClusterIP`, `NodePort`, `LoadBalancer`).

### ❌ DNS resolution failing inside Pod

**Fix:**

```bash
kubectl exec -it <pod> -- nslookup kubernetes.default
kubectl get pods -n kube-system -l k8s-app=kube-dns
```

Restart CoreDNS if needed:

```bash
kubectl rollout restart deployment coredns -n kube-system
```

---

## 4. Deployment Issues

### ❌ Rollout stuck

**Fix:**

```bash
kubectl rollout status deployment <deploy-name>
```

Check Pod template changes → fix invalid image or configuration.

### ❌ Undo rollout

```bash
kubectl rollout undo deployment <deploy-name>
```

### ❌ Desired replicas not matching available

**Cause:**
Insufficient resources or failing Pods.
**Fix:** Check Pods’ `kubectl describe` and logs.

---

## 5. PersistentVolume & PVC Issues

### ❌ PVC stuck in `Pending`

**Cause:** No available PV or StorageClass misconfiguration.
**Fix:**

```bash
kubectl describe pvc <pvc-name>
```

Ensure a PV or dynamic provisioner exists.

### ❌ Volume mount failed

**Fix:**

* Verify `mountPath` is correct.
* Check events in `kubectl describe pod`.
* Ensure node has CSI driver.

### ❌ ReclaimPolicy not working

**Cause:** PV configured with `Retain`.
**Fix:** Manually delete or cleanup PV resource after PVC deletion.

---

## 6. ConfigMap & Secret Issues

### ❌ ConfigMap not found

**Fix:**
Ensure namespace consistency.

```bash
kubectl get configmap -n <namespace>
```

### ❌ Secret decode issues

**Fix:**
Ensure value is base64 encoded properly:

```bash
echo -n 'myvalue' | base64
echo 'bXl2YWx1ZQ==' | base64 --decode
```

---

## 7. Helm & Manifest Errors

### ❌ Helm install failed: `another operation in progress`

**Fix:**

```bash
helm rollback <release> <revision>
```

Or delete failed release:

```bash
helm uninstall <release>
```

### ❌ YAML validation failed

**Fix:**
Validate manifest syntax:

```bash
kubectl apply --dry-run=client -f <file>.yaml
```

---

## 8. ImagePull & Registry Errors

### ❌ `ErrImagePull` or `ImagePullBackOff`

**Fix:**

* Check image path and tag.
* If private, configure `imagePullSecrets`.
* Ensure network access to registry.

---

## 9. RBAC & Permission Issues

### ❌ `Forbidden` errors when using `kubectl`

**Cause:** ServiceAccount or user lacks permissions.
**Fix:**

```bash
kubectl auth can-i get pods --as system:serviceaccount:<ns>:<sa>
```

Add necessary Role or ClusterRoleBinding.

### ❌ Pod cannot list resources

**Fix:**
Attach proper RBAC permissions to Pod’s ServiceAccount.

---

## 10. General Debugging Commands

```bash
kubectl get all --all-namespaces
kubectl describe pod <pod-name>
kubectl logs <pod-name>
kubectl get events --sort-by=.metadata.creationTimestamp
kubectl top nodes
kubectl top pods
```

Debug interactively:

```bash
kubectl exec -it <pod-name> -- /bin/sh
```

Cluster health:

```bash
kubectl get componentstatuses
kubectl get nodes -o wide
```

---

## ✅ Tips

* Always check `kubectl describe` for Events.
* Use namespaces consistently.
* Validate YAML with `--dry-run=client`.
* Watch rollouts: `kubectl rollout status`.
* Clean up old resources: `kubectl delete pod --force --grace-period=0` (use carefully).

---

## 📘 Interview Quick Q&A

**Q: How do you debug a Pod stuck in Pending?**

> Describe the Pod, check node resources, and ensure PVC or taint issues are resolved.

**Q: What’s the difference between CrashLoopBackOff and ImagePullBackOff?**

> CrashLoopBackOff means the container starts and crashes repeatedly; ImagePullBackOff means the image couldn’t be pulled from registry.

**Q: How to check which Pod uses the most CPU?**

> Use `kubectl top pods`.

**Q: How do you debug a Service connectivity issue?**

> Check endpoints, service type, and DNS resolution within Pods.

---

## End of File — Kubernetes Common Issues and Fixes
