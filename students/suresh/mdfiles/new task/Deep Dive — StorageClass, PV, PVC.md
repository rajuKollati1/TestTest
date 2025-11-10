# Kubernetes Storage Deep Dive — StorageClass, PV, PVC

This document is a **step-by-step** guide and ready-to-save Markdown file that explains Kubernetes storage primitives: **StorageClass**, **PersistentVolume (PV)**, and **PersistentVolumeClaim (PVC)**. It includes examples, commands, and troubleshooting notes for hands-on practice and interview prep.

---

## Table of Contents

1. Overview (quick)
2. Prerequisites
3. Step-by-step: Static PV + PVC
4. Step-by-step: Dynamic provisioning using StorageClass
5. Using PVC in a Pod
6. Reclaim policies and lifecycle
7. Access modes explained
8. Common commands
9. Troubleshooting
10. Interview questions & short answers

---

## 1. Overview (quick)

* **PV (PersistentVolume)**: A cluster resource representing physical storage (NFS, hostPath, cloud disk, etc.).
* **PVC (PersistentVolumeClaim)**: A request for storage (size, access mode). PVCs are namespaced.
* **StorageClass**: Describes how to dynamically provision PVs (driver, parameters, reclaim policy, etc.).

---

## 2. Prerequisites

* A working Kubernetes cluster (minikube, kind, or cloud cluster).
* `kubectl` configured to talk to the cluster.
* If using cloud dynamic provisioning, ensure your cloud provider's storage CSI is installed (minikube often provides a default storage class).

Quick check:

```bash
kubectl version --short
kubectl get nodes
```

---

## 3. Step-by-step: Static PV + PVC

**Goal:** Create a static PV and then create a PVC that binds to it.

### Step 1 — Create a static PV manifest (example uses `hostPath` — for lab/demo only):

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: demo-pv
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  hostPath:
    path: /mnt/data/demo-pv
```

Save as `pv-demo.yaml` and apply:

```bash
kubectl apply -f pv-demo.yaml
kubectl get pv demo-pv
```

### Step 2 — Create a PVC that matches the PV:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: demo-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```

Save as `pvc-demo.yaml` and apply:

```bash
kubectl apply -f pvc-demo.yaml
kubectl get pvc demo-pvc
kubectl get pv            # check for STATUS: Bound
```

**Notes:**

* Binding: Kubernetes matches PVC to a suitable PV by size, access modes, and any `storageClassName` (if specified).
* If PVC remains `Pending`, inspect `kubectl describe pvc demo-pvc` to see why.

---

## 4. Step-by-step: Dynamic provisioning using StorageClass

**Goal:** Let Kubernetes create PVs on demand via a StorageClass.

### Step 1 — Inspect existing StorageClasses:

```bash
kubectl get storageclass
kubectl describe storageclass <name>
```

Many clusters (minikube, GKE, EKS, AKS) already have a default StorageClass.

### Step 2 — Create a StorageClass (example: generic template)

> Replace `provisioner` and `parameters` with the appropriate CSI driver details for your environment (AWS, GCE, OpenEBS, local-path, etc.).

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: fast-ssd
provisioner: kubernetes.io/no-provisioner # example for local static; for dynamic use a CSI driver name
volumeBindingMode: WaitForFirstConsumer
reclaimPolicy: Delete
parameters:
  type: gp2
```

Save as `sc-fast-ssd.yaml` and apply:

```bash
kubectl apply -f sc-fast-ssd.yaml
kubectl get storageclass
```

### Step 3 — Create a PVC that requests dynamic provisioning:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: dynamic-pvc
spec:
  storageClassName: fast-ssd
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
```

Apply and check:

```bash
kubectl apply -f pvc-dynamic.yaml
kubectl get pvc dynamic-pvc
kubectl get pv            # you should see a PV created by the provisioner
```

**Notes:**

* If the StorageClass `provisioner` is set correctly and the cluster has permissions, the CSI/controller will create a PV automatically.
* `volumeBindingMode: WaitForFirstConsumer` delays actual volume binding until a Pod requests the PVC (useful for topology-aware provisioning).

---

## 5. Using a PVC in a Pod

Create a Pod manifest that mounts the PVC.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-with-pvc
spec:
  containers:
  - name: app
    image: nginx
    volumeMounts:
    - mountPath: /usr/share/nginx/html
      name: app-storage
  volumes:
  - name: app-storage
    persistentVolumeClaim:
      claimName: dynamic-pvc
```

Apply:

```bash
kubectl apply -f pod-with-pvc.yaml
kubectl exec -it app-with-pvc -- ls /usr/share/nginx/html
```

---

## 6. Reclaim policies and lifecycle

* `Retain`: Keep the PV after PVC is deleted — manual cleanup required.
* `Delete`: Delete the underlying storage asset when PV is deleted (common with cloud volumes).
* `Recycle` (deprecated/removed in many distros): Basic scrub then reuse.

Lifecycle example:

1. PVC created -> PV bound (or dynamically provisioned)
2. Pod uses PVC
3. Delete Pod
4. Delete PVC -> PV's reclaim policy applies

---

## 7. Access modes explained

* `ReadWriteOnce (RWO)`: Mounted RW by a single node (most common).
* `ReadOnlyMany (ROX)`: Read-only by many nodes.
* `ReadWriteMany (RWX)`: RW by many nodes (requires special backends like NFS, CephFS, or CSI drivers supporting RWX).

---

## 8. Common commands

```bash
kubectl get pv
kubectl get pvc
kubectl get storageclass
kubectl describe pv <pv-name>
kubectl describe pvc <pvc-name>
kubectl delete pvc <pvc-name>
kubectl delete pv <pv-name>
```

---

## 9. Troubleshooting

* **PVC stuck `Pending`:** `kubectl describe pvc` -> mismatch in size/accessModes or no matching PV or provisioner failure.
* **PV `Available` but PVC not bound:** Check `storageClassName` and selectors (labels) on PV and PVC.
* **Permission errors on dynamic provisioning:** Check CSI controller logs, RBAC, cloud IAM permissions.
* **Volume mount failed in Pod:** `kubectl describe pod` for events; may indicate Node can't access volume (zone topology issue) or driver missing.

Useful commands:

```bash
kubectl logs -n kube-system <csi-controller-pod>
kubectl describe pod <pod-name>
```

---

## 10. Interview questions & short answers

**Q: What is a PV and PVC?**
A: PV is cluster storage resource; PVC is a namespaced request for storage.

**Q: What is StorageClass used for?**
A: Describes how dynamic provisioning should occur (provisioner, parameters, reclaim policy).

**Q: How does dynamic provisioning work?**
A: PVC references a StorageClass; the provisioner (CSI) creates a PV on-demand that satisfies the claim.

**Q: What is `volumeBindingMode: WaitForFirstConsumer`?**
A: It delays binding/provisioning until a Pod using the PVC is scheduled, enabling topology-aware provisioning.

**Q: Difference between `Retain` and `Delete` reclaim policies?**
A: `Retain` preserves the physical volume after PVC deletion for manual recovery; `Delete` removes it automatically.

---

## Appendix: Useful examples & manifests

* `pv-demo.yaml` (static PV) — see section 3
* `pvc-demo.yaml` (PVC) — see section 3
* `sc-fast-ssd.yaml` (StorageClass) — see section 4
* `pvc-dynamic.yaml` (dynamic PVC) — see section 4
* `pod-with-pvc.yaml` (Pod using PVC) — see section 5

---

## Final notes

* For production, prefer **CSI drivers** and dynamic provisioning with well-configured StorageClasses.
* Be mindful of **access modes**, **topology (zones)**, and **reclaim policies** when designing storage for stateful workloads.

---

