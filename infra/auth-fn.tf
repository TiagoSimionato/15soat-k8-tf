resource "kubernetes_service" "auth_fn" {
  metadata {
    name      = "auth-fn-svc"
    namespace = var.namespace
  }
  spec {
    type          = "ExternalName"
    external_name = "host.docker.internal"
    port {
      port = var.serverless_port
    }
  }
}