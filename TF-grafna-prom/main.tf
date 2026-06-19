terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.25.2"
    }
  }
}

# Providers will automatically use the default kubeconfig on your laptop
provider "helm" {
  kubernetes {
    config_path = pathexpand("~/.kube/config")
  }
}

provider "kubernetes" {
  config_path = pathexpand("~/.kube/config")
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

# 3. Persistent Volumes for Monitoring
resource "kubernetes_persistent_volume_claim" "prometheus_pvc" {
  metadata {
    name      = "prometheus-server-pvc"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }
  wait_until_bound = false
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "2Gi"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "grafana_pvc" {
  metadata {
    name      = "grafana-pvc"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }
  wait_until_bound = false
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }
}

# 4. Install Prometheus (Lightweight)
resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  depends_on = [
    kubernetes_persistent_volume_claim.prometheus_pvc
  ]
  
  wait = false # Don't wait for pods to be "Ready" so you can debug if they stay Pending

  set {
    name  = "alertmanager.enabled"
    value = "false" # Disabled to save RAM
  }
  set {
    name  = "pushgateway.enabled"
    value = "false" # Disabled to save RAM
  }
  set {
    name  = "kube-state-metrics.enabled"
    value = "false" # Disabled to avoid image pull errors and save resources
  }
  set {
    name  = "server.persistentVolume.existingClaim"
    value = kubernetes_persistent_volume_claim.prometheus_pvc.metadata[0].name
  }
  
  # Resource constraints
  set {
    name  = "server.resources.requests.memory"
    value = "256Mi"
  }
  set {
    name  = "server.resources.limits.memory"
    value = "512Mi"
  }
  set {
    name  = "server.resources.requests.cpu"
    value = "100m"
  }
}

# 5. Install Grafana (Lightweight)
resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  depends_on = [
    kubernetes_persistent_volume_claim.grafana_pvc
  ]

  wait = false # Don't wait for pods to be "Ready"

  set {
    name  = "persistence.enabled"
    value = "true"
  }
  set {
    name  = "persistence.existingClaim"
    value = kubernetes_persistent_volume_claim.grafana_pvc.metadata[0].name
  }
  set {
    name  = "adminPassword"
    value = "admin123"
  }

  # Resource constraints
  set {
    name  = "resources.requests.memory"
    value = "128Mi"
  }
  set {
    name  = "resources.limits.memory"
    value = "256Mi"
  }
  set {
    name  = "resources.requests.cpu"
    value = "50m"
  }
}
