# Helm Guide

## Overview
Helm simplifies Kubernetes application management using charts.

### Basic Commands
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm search repo grafana
helm install grafana grafana/grafana --namespace monitoring
helm list -n monitoring
helm uninstall grafana -n monitoring
```
> 💡 Always use namespaces for better isolation.

### Upgrade Example
```bash
helm upgrade grafana grafana/grafana -n monitoring --set persistence.enabled=true
```

### Custom Values Example
```yaml
persistence:
  enabled: true
  size: 5Gi
adminUser: admin
adminPassword: strongpassword
```
