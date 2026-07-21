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

provider "helm" {
  kubernetes {
    config_path = pathexpand("~/.kube/config")
  }
}

provider "kubernetes" {
  config_path = pathexpand("~/.kube/config")
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "kubernetes_persistent_volume_claim" "argocd_pvc" {
  metadata {
    name      = "argocd-pvc"
    namespace = kubernetes_namespace.argocd.metadata[0].name
  }

  wait_until_bound = false

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "10Gi"
      }
    }
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  version    = "7.0.0"

  depends_on = [
    kubernetes_persistent_volume_claim.argocd_pvc
  ]

  wait = false

  # ===== SERVER CONFIGURATION =====
  set {
    name  = "server.service.type"
    value = "NodePort"
  }

  set {
    name  = "server.service.nodePort"
    value = "30080"
  }

  set {
    name  = "server.insecure"
    value = "true"
  }

  # ===== PERSISTENCE CONFIGURATION =====
  set {
    name  = "persistence.enabled"
    value = "true"
  }

  set {
    name  = "persistence.existingClaim"
    value = kubernetes_persistent_volume_claim.argocd_pvc.metadata[0].name
  }

  # ===== SERVER RESOURCE LIMITS =====
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

  set {
    name  = "server.resources.limits.cpu"
    value = "500m"
  }

  # ===== REPO SERVER RESOURCE LIMITS =====
  set {
    name  = "repoServer.resources.requests.memory"
    value = "256Mi"
  }

  set {
    name  = "repoServer.resources.limits.memory"
    value = "512Mi"
  }

  set {
    name  = "repoServer.resources.requests.cpu"
    value = "100m"
  }

  set {
    name  = "repoServer.resources.limits.cpu"
    value = "500m"
  }

  # ===== APPLICATION CONTROLLER RESOURCE LIMITS =====
  set {
    name  = "controller.resources.requests.memory"
    value = "256Mi"
  }

  set {
    name  = "controller.resources.limits.memory"
    value = "512Mi"
  }

  set {
    name  = "controller.resources.requests.cpu"
    value = "100m"
  }

  set {
    name  = "controller.resources.limits.cpu"
    value = "500m"
  }

  # ===== DEX SERVER RESOURCE LIMITS =====
  set {
    name  = "dex.resources.requests.memory"
    value = "128Mi"
  }

  set {
    name  = "dex.resources.limits.memory"
    value = "256Mi"
  }

  set {
    name  = "dex.resources.requests.cpu"
    value = "50m"
  }

  set {
    name  = "dex.resources.limits.cpu"
    value = "200m"
  }

  # ===== NOTIFICATIONS CONTROLLER RESOURCE LIMITS =====
  set {
    name  = "notifications.resources.requests.memory"
    value = "128Mi"
  }

  set {
    name  = "notifications.resources.limits.memory"
    value = "256Mi"
  }

  set {
    name  = "notifications.resources.requests.cpu"
    value = "50m"
  }

  set {
    name  = "notifications.resources.limits.cpu"
    value = "200m"
  }
}

# Output information
output "argocd_namespace" {
  description = "ArgoCD namespace"
  value       = kubernetes_namespace.argocd.metadata[0].name
}

output "argocd_server_url_nodeport" {
  description = "ArgoCD Server URL via NodePort"
  value       = "http://<node-ip>:30080"
}

output "argocd_server_url_portforward" {
  description = "ArgoCD Server URL via Port Forward"
  value       = "http://localhost:8080 (after running: kubectl port-forward -n argocd svc/argocd-server 8080:443)"
}

output "initial_password_command" {
  description = "Command to retrieve initial admin password"
  value       = "Run the script: powershell -ExecutionPolicy Bypass -File './get-password.ps1'"
}

output "set_password_command" {
  description = "Command to set new admin password"
  value       = "Run the script: powershell -ExecutionPolicy Bypass -File './set-password.ps1' -NewPassword 'your-password'"
}
