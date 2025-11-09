# Grafana and Prometheus Installation on Kubernetes (Helm)

## Step 1: Add Helm Repositories
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
```

## Step 2: Install Prometheus
```bash
helm install prometheus prometheus-community/prometheus --namespace monitoring --create-namespace
```

## Step 3: Install Grafana
```bash
helm install grafana grafana/grafana --namespace monitoring
kubectl get svc -n monitoring
```

## Step 4: Access Grafana
- Use `kubectl port-forward svc/grafana 3000:80 -n monitoring`
- Login using default credentials: `admin / prom-operator`

## Step 5: Import Dashboards
1. Go to [Grafana Dashboards](https://grafana.com/grafana/dashboards)
2. Copy dashboard ID (e.g., 1860 for Node Exporter)
3. Import in Grafana → Dashboards → Import → Paste ID → Load → Save

