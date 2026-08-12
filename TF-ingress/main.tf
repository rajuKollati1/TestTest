resource "kubernetes_namespace" "ingress_nginx" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.10.1" # Pinning the chart version for consistent deployments
  namespace  = kubernetes_namespace.ingress_nginx.metadata[0].name

  # Values to configure the ingress controller.
  # For production, you might want to customize these further.
  values = [
    yamlencode({
      controller = {
        replicaCount = 2
        service = {
          type = "LoadBalancer"
        }
      }
    })
  ]
}
