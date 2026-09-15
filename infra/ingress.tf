resource "kubernetes_ingress_v1" "app" {
  metadata {
    name      = "app-15soat-tech-challenge"
    namespace = kubernetes_namespace.app.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class" = "traefik"
    }
  }

  spec {
    rule {
      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "app-svc-15soat-tech-challenge"
              port {
                number = 3000
              }
            }
          }
        }
      }
    }
  }

  depends_on = [kubernetes_deployment.traefik]
}

resource "kubernetes_ingress_v1" "auth_fn" {
  metadata {
    name      = "auth-fn"
    namespace = kubernetes_namespace.app.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class" = "traefik"
    }
  }

  spec {
    rule {
      http {
        path {
          path      = "/auth"
          path_type = "Prefix"

          backend {
            service {
              name = "auth-fn-svc"
              port {
                number = 3001
              }
            }
          }
        }
      }
    }
  }

  depends_on = [kubernetes_deployment.traefik]
}