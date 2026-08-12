variable "namespace" {
  description = "The Kubernetes namespace to deploy the NGINX Ingress Controller into."
  type        = string
  default     = "ingress-nginx"
}

variable "app_namespace" {
  description = "The namespace where the application (e.g., nginx) is running."
  type        = string
  default     = "default"
}

variable "app_service_name" {
  description = "The name of the application's service to expose."
  type        = string
  default     = "nginx-service"
}

variable "ingress_hostname" {
  description = "The hostname for the ingress rule."
  type        = string
  default     = "nginx.example.com"
}