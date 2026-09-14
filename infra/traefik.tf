resource "kubernetes_service_account" "traefik" {
    metadata {
        name = "traefik"
        namespace = kubernetes_namespace.app.metadata[0].name
    }
}

resource "kubernetes_cluster_role" "traefik" {
  metadata {
    name = "traefik-role"
  }

  rule {
    api_groups = [""]
    resources  = ["services", "endpoints", "secrets", "nodes"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["discovery.k8s.io"]
    resources  = ["endpointslices"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["networking.k8s.io"]
    resources  = ["ingresses", "ingressclasses"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["networking.k8s.io"]
    resources  = ["ingresses/status"]
    verbs      = ["update"]
  }
}

resource "kubernetes_cluster_role_binding" "traefik" {
  metadata {
    name = "traefik-role-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.traefik.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.traefik.metadata[0].name
    namespace = kubernetes_namespace.app.metadata[0].name
  }
}

resource "kubernetes_deployment" "traefik" {
  metadata {
    name      = "traefik-15soat-tech-challenge"
    namespace = kubernetes_namespace.app.metadata[0].name
    labels    = { app = "traefik-15soat-tech-challenge" }
  }

  spec {
    replicas = 1

    selector {
      match_labels = { app = "traefik-15soat-tech-challenge" }
    }

    template {
      metadata {
        name   = "traefik-15soat-tech-challenge"
        labels = { app = "traefik-15soat-tech-challenge" }
      }

      spec {
        service_account_name = kubernetes_service_account.traefik.metadata[0].name

        container {
          name  = "traefik"
          image = "traefik:v3.1"

          args = [
            "--entrypoints.web.address=:80",
            "--entrypoints.traefik.address=:8080",
            "--providers.kubernetesingress=true",
            "--api.dashboard=true",
            "--api.insecure=true",
            "--log.level=INFO",
          ]

          port {
            name           = "web"
            container_port = 80
          }
          port {
            name           = "dashboard"
            container_port = 8080
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_cluster_role_binding.traefik,
  ]
}

resource "kubernetes_service" "traefik" {
  metadata {
    name      = "traefik-svc-tech-challenge"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  spec {
    selector = { app = "traefik-15soat-tech-challenge" }

    type = "NodePort"

    port {
      name        = "web"
      port        = 80
      target_port = 80
      node_port   = 30080
    }
    port {
      name        = "dashboard"
      port        = 8080
      target_port = 8080
      node_port   = 30900
    }

  }

  depends_on = [kubernetes_namespace.app]
}
