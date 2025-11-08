# Install Prometheus and Grafana on Kubernetes using Helm (step-by-step)

> This guide shows a reproducible, minimal setup for **Prometheus** and **Grafana** on a Kubernetes cluster using **Helm 3**. It covers namespace creation, Helm repo setup, sample `values.yaml` for persistence, accessing UIs (port-forward, NodePort, or Ingress), and basic troubleshooting.

---

## Prerequisites

* A Kubernetes cluster (v1.16+ recommended) and `kubectl` configured to talk to it.
* Helm 3 installed and configured. (Check with `helm version`.)
* Optional: `kubectl port-forward` available on your machine for quick access.
* Optional: StorageClass available in your cluster for PVCs (for persistence).

---

## Overview

We'll install:

* **Prometheus** (using the community Helm chart `prometheus-community/prometheus`) — for metrics scraping and storage.
* **Grafana** (using the official chart `grafana/grafana`) — for dashboards and visualization.

Two installation approaches:

1. **Separate charts** (recommended for clarity): `prometheus` + `grafana`.
2. **kube-prometheus-stack** (a single, opinionated bundle with Prometheus Operator + Grafana). If you want the operator features (CRDs, ServiceMonitors, Alertmanager integrated), use the `kube-prometheus-stack` chart instead.

This guide uses the **separate charts** approach, with notes for the stack at the end.

---

## 1) Create namespaces (optional but recommended)

```bash
kubectl create ns monitoring
kubectl create ns grafana
```

(Or put both in `monitoring` if you prefer a single namespace.)

---

## 2) Add and update Helm repos

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
```

---

## 3) Install Prometheus (simple example)

### Minimal install (no persistence)

```bash
helm install prometheus prometheus-community/prometheus --namespace monitoring
```

### Install with persistence and basic resource requests

Create a `prometheus-values.yaml` with contents like:

```yaml
server:
  persistentVolume:
    enabled: true
    size: 8Gi
  resources:
    requests:
      memory: 512Mi
      cpu: 250m
alertmanager:
  persistentVolume:
    enabled: true
    size: 2Gi
pushgateway:
  enabled: false

# If you run in a cloud-managed K8s with StorageClass, the PVC will be dynamically provisioned.
```

Install using:

```bash
helm install prometheus prometheus-community/prometheus -n monitoring -f prometheus-values.yaml
```

### Verify the install

```bash
kubectl get pods -n monitoring
kubectl get svc -n monitoring
```

Prometheus server service name will typically be `prometheus-server` (check `kubectl get svc -n monitoring`).

---

## 4) Access Prometheus UI (port-forward or NodePort/LoadBalancer)

**Port-forward (local quick access):**

```bash
kubectl -n monitoring port-forward svc/prometheus-server 9090:80
# then open http://localhost:9090
```

**Expose with NodePort (example):**

> Add a small patch or use `--set server.service.type=NodePort` during install.

```bash
helm upgrade --install prometheus prometheus-community/prometheus -n monitoring -f prometheus-values.yaml \
  --set server.service.type=NodePort --set server.service.nodePort=30090
```

Then access `http://<node-ip>:30090`.

---

## 5) Install Grafana

Create a `grafana-values.yaml` to configure persistence, admin password, and service type. Example:

```yaml
persistence:
  enabled: true
  size: 10Gi
  # storageClassName: "standard"  # optional: specify your StorageClass

adminUser: admin
adminPassword: grafana123   # change this for production or use a Kubernetes Secret

service:
  type: ClusterIP    # or NodePort / LoadBalancer if you want external access

ingress:
  enabled: false     # enable and configure if you use Ingress

# Optionally configure datasources to auto-provision Prometheus as a datasource
# so Grafana will automatically have Prometheus linked.
datasources:
  datasources.yaml:
    apiVersion: 1
    datasources:
      - name: Prometheus
        type: prometheus
        access: proxy
        url: http://prometheus-server.monitoring.svc.cluster.local
        isDefault: true
```

Install Grafana in `grafana` namespace (or `monitoring`):

```bash
helm install grafana grafana/grafana -n grafana -f grafana-values.yaml
```

Or install into `monitoring` so grafana can reach Prometheus via cluster DNS without changing URLs:

```bash
helm install grafana grafana/grafana -n monitoring -f grafana-values.yaml
```

---

## 6) Get Grafana admin password

If you didn't set `adminPassword` in `values.yaml`, Helm chart creates a secret. Retrieve it with:

```bash
kubectl get secret -n grafana grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

If you installed in `monitoring` namespace, replace `-n grafana` with `-n monitoring` and secret name may be `<release-name>-admin` or `grafana` depending on chart version. Check with:

```bash
kubectl get secrets -n grafana
```

---

## 7) Access Grafana UI (port-forward / NodePort / Ingress)

**Port-forward (quick local):**

```bash
kubectl -n grafana port-forward svc/grafana 3000:80
# open http://localhost:3000
# default login: admin / grafana123  (or the password you set)
```

**NodePort example:** set `service.type=NodePort` and `service.nodePort=32000` in `grafana-values.yaml` or use `--set`.

**Ingress:** If you have an Ingress controller, enable `ingress.enabled=true` and provide host rules.

---

## 8) Configure Grafana datasource to point to Prometheus

If you added the `datasources` section in `grafana-values.yaml`, Grafana will auto-provision a Prometheus datasource.

Otherwise, add it manually in Grafana UI under **Configuration → Data Sources → Add data source**:

* Type: Prometheus
* URL: `http://prometheus-server.monitoring.svc.cluster.local` (if both are in `monitoring` namespace)
* Access: Server (default)

---

## 9) Import dashboards

Grafana has many community dashboards. Search by name or import via dashboard ID. The Prometheus community maintains useful dashboards like node-exporter, kube-state-metrics, and cluster monitoring dashboards.

---

## 10) Optional — kube-prometheus-stack (single-chart alternative)

If you prefer an integrated setup (Prometheus Operator, ServiceMonitors, Alertmanager, Grafana, node-exporter), use `kube-prometheus-stack`:

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install kube-prom-stack prometheus-community/kube-prometheus-stack -n monitoring
```

This chart installs many CRDs and components; read its `values.yaml` before enabling persistence or changing defaults.

---

## 11) Troubleshooting

* `kubectl get pods -n monitoring` — check pod statuses.
* `kubectl logs <pod> -n monitoring` — inspect logs for Prometheus/Grafana pods.
* If PVCs are `Pending`, verify StorageClass exists and dynamic provisioning is supported. Use `kubectl get sc`.
* If Grafana login fails, check the secret for admin password and that you're using the correct namespace.
* If Prometheus targets are missing, ensure exporters (node-exporter, kube-state-metrics) are installed and ServiceMonitors are configured, or add scrape configs.

---

## 12) Cleanup (uninstall)

```bash
helm uninstall prometheus -n monitoring
helm uninstall grafana -n grafana
kubectl delete ns monitoring grafana
```

---

## 13) Example quick commands (copy-paste)

```bash
# namespaces
kubectl create ns monitoring
kubectl create ns grafana

# add repos
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# install prometheus (simple)
helm install prometheus prometheus-community/prometheus -n monitoring

# install grafana (simple)
helm install grafana grafana/grafana -n grafana --set adminPassword=grafana123

# port-forward
kubectl -n monitoring port-forward svc/prometheus-server 9090:80
kubectl -n grafana port-forward svc/grafana 3000:80
```

---

## Notes & Best Practices

* Use strong credentials and store them as Kubernetes Secrets.
* Use persistent storage for Prometheus server if you want durable metrics (note: Prometheus local storage is not a long-term storage solution; for long-term retention consider remote-write to Thanos/Cortex/Prometheus remote storage).
* For production, prefer `kube-prometheus-stack` if you want operator-managed ServiceMonitors and CRD-based service discovery.
* Secure Grafana with an Ingress that uses TLS and/or enable authentication (OAuth/LDAP) for team access.

---

If you want, I can also:

* Provide ready-to-use `prometheus-values.yaml` and `grafana-values.yaml` tuned for a 3-node lab cluster.
* Show `helm install` commands that set NodePort/Ingress automatically.
* Create a full `kube-prometheus-stack` values file for production-like setup.

---

*End of guide.*
