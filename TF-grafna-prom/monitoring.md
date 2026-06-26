# Monitoring Setup: Prometheus & Grafana

This document provides details for the lightweight monitoring stack deployed in the `monitoring` namespace.

## 1. Grafana Credentials
- **Username:** `admin`
- **Password:** `admin123` (Configured in `main.tf`)

## 2. Deployment Details
The setup is optimized for a lightweight lab environment:
- **Namespace:** `monitoring`
- **Prometheus:** 
    - Resources: 256Mi Memory / 100m CPU
    - Persistence: 2Gi PVC (`prometheus-server-pvc`)
    - Disabled: Alertmanager, Pushgateway, Kube-State-Metrics
- **Grafana:**
    - Resources: 128Mi Memory / 50m CPU
    - Persistence: 1Gi PVC (`grafana-pvc`)

## 3. Accessing Dashboards
### Grafana
```bash
kubectl port-forward deployment/grafana -n monitoring 3000:3000
```
Access at: `http://localhost:3000`

#### Chartvalues in grafana
helm pull grafana/grafana --version 10.5.15 --untar 

#### values values in grafna
helm show values grafana/grafana --version 10.5.15 > original-values.yaml

### Add custom values to granfa

helm upgrade grafana grafana/grafana -n monitoring -f custom-values.yaml

securityContext:
  runAsUser: 472
  runAsGroup: 472
  fsGroup: 472

#### granfa username and pss
admin
bash
kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo



### Prometheus
```bash
kubectl port-forward deployment/prometheus-server -n monitoring 9090:9090
```
Access at: `http://localhost:9090`

## 4. Troubleshooting
- **PVC Pending:** The PVCs are configured with `wait_until_bound = false`. They will transition to `Bound` once the pods are successfully scheduled to a node.
- **Image Pull Errors:** Kube-state-metrics is disabled to avoid registry connection issues and save resources.git 