resource "kubernetes_secret" "app-secrets" {
  metadata {
    name      = "secrets-15soat"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  type = "Opaque"

  data = {
    CLIENT_ID                = var.client_id
    CLIENT_SECRET            = var.client_secret
    AUTHORIZATION_SERVER_URL = var.authorization_server_url
    JWT_SECRET               = var.jwt_secret
  }
}