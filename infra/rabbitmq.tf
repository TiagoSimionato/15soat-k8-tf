resource "kubernetes_service" "rabbitmq" {
  metadata {
    name      = "svc-rabbitmq"
    namespace = kubernetes_namespace.app.metadata[0].name
    labels    = { app = "rabbitmq" }
  }

  spec {
    selector = { app = "rabbitmq" }

    port {
      name        = "amqp"
      port        = 5672
      target_port = 5672
    }

    port {
      name        = "management"
      port        = 15672
      target_port = 15672
      node_port   = 30006
    }

    type = "NodePort"
  }

  depends_on = [kubernetes_namespace.app]
}

resource "kubernetes_deployment" "rabbitmq" {
  metadata {
    name      = "rabbitmq"
    namespace = kubernetes_namespace.app.metadata[0].name
    labels    = { app = "rabbitmq" }
  }

  spec {
    replicas = 1

    selector {
      match_labels = { app = "rabbitmq" }
    }

    template {
      metadata {
        labels = { app = "rabbitmq" }
      }

      spec {
        container {
          name  = "rabbitmq"
          image = "rabbitmq:3-management"

          env {
            name  = "RABBITMQ_DEFAULT_USER"
            value = var.rabbitmq_user
          }
          env {
            name  = "RABBITMQ_DEFAULT_PASS"
            value = var.rabbitmq_password
          }

          port {
            container_port = 5672
          }

          port {
            container_port = 15672
          }

          readiness_probe {
            tcp_socket {
              port = 5672
            }
            initial_delay_seconds = 10
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 3
          }

          liveness_probe {
            tcp_socket {
              port = 5672
            }
            initial_delay_seconds = 30
            period_seconds        = 15
            timeout_seconds       = 5
            failure_threshold     = 3
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_service.rabbitmq,
  ]
}
