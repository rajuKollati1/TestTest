resource "kubernetes_ingress_v1" "nginx_ingress" {
  wait_for_load_balancer = true

  metadata {
    name      = "nginx-ingress"
    namespace = var.app_namespace
  }

  spec {
    ingress_class_name = "nginx"

    rule {
      host = var.ingress_hostname
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = var.app_service_name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}