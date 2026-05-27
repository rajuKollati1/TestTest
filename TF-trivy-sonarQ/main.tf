terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12.1"
    }
  }
}

# Terraform automatically looks for your kubeconfig at ~/.kube/config
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config" 
  }
}

# 1. Install SonarQube
resource "helm_release" "sonarqube" {
  name             = "sonarqube"
  repository       = "https://SonarSource.github.io/helm-chart-sonarqube"
  chart            = "sonarqube"
  namespace        = "devops"
  create_namespace = true
  
  timeout = 900 # Increase to 15 minutes for slow-starting SonarQube pods

  set {
    name  = "account.adminPassword" # Changed from 'raju' to a more likely intended key
    value = "VMware1!"              # Added missing closing quote
  }

  set {
    name  = "monitoringPasscode"
    value = "Ra!u@98858834" # Required by newer SonarQube chart versions
  }

  set {
    name  = "community.enabled"
    value = "true"
  }

  # --- Lightweight Configuration ---
  
  # 1. Limit the JVM heap for the Web process
  set {
    name  = "jvmOpts"
    value = "-Xmx384m -Xms384m"
  }

  # 2. Limit the JVM heap for the Search (Elasticsearch) process
  set {
    name  = "search.javaOpts"
    value = "-Xmx384m -Xms384m"
  }

  # 3. Set K8s resource requests (Total pod memory)
  set {
    name  = "resources.requests.memory"
    value = "768Mi"
  }
  set {
    name  = "resources.requests.cpu"
    value = "100m"
  }

  # 4. Persistence and Database settings
  set {
    name  = "persistence.enabled"
    value = "false" # Set to false to save IO/Disk; data will be lost on pod restart
  }
  
  set {
    name  = "postgresql.enabled"
    value = "true"
  }
  # ---------------------------------
}

# 2. Install Trivy Operator
# This is better than the CLI version for K8s because it scans 24/7
resource "helm_release" "trivy_operator" {
  name             = "trivy-operator"
  repository       = "https://aquasecurity.github.io/helm-charts/"
  chart            = "trivy-operator"
  namespace        = "trivy-system"
  create_namespace = true

  set {
    name  = "trivy.ignoreUnfixed"
    value = "true"
  }
}