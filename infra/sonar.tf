resource "kubernetes_service" "sonar_postgres" {
	metadata {
		name      = "svc-sonar-postgres"
		namespace = kubernetes_namespace.app.metadata[0].name
		labels    = { app = "sonar-postgres" }
	}

	spec {
		selector = { app = "sonar-postgres" }

		port {
			name        = "postgres"
			port        = 5432
			target_port = 5432
		}

		type = "ClusterIP"
	}

	depends_on = [kubernetes_namespace.app]
}

resource "kubernetes_deployment" "sonar_postgres" {
	metadata {
		name      = "sonar-postgres"
		namespace = kubernetes_namespace.app.metadata[0].name
		labels    = { app = "sonar-postgres" }
	}

	spec {
		replicas = 1

		selector {
			match_labels = { app = "sonar-postgres" }
		}

		template {
			metadata {
				labels = { app = "sonar-postgres" }
			}

			spec {
				container {
					name  = "sonar-postgres"
					image = "postgres:latest"

					env {
						name  = "POSTGRES_USER"
						value = var.sonar_postgres_user
					}
					env {
						name  = "POSTGRES_PASSWORD"
						value = var.sonar_postgres_password
					}
					env {
						name  = "POSTGRES_DB"
						value = var.sonar_postgres_db
					}

					port {
						container_port = 5432
					}
				}
			}
		}
	}

	depends_on = [
		kubernetes_service.sonar_postgres,
	]
}

resource "kubernetes_service" "sonarqube" {
	metadata {
		name      = "svc-sonarqube"
		namespace = kubernetes_namespace.app.metadata[0].name
		labels    = { app = "sonarqube" }
	}

	spec {
		selector = { app = "sonarqube" }

		port {
			name        = "http"
			port        = 9000
			target_port = 9000
			node_port   = 30005
		}

		type = "NodePort"
	}

	depends_on = [kubernetes_namespace.app]
}

resource "kubernetes_deployment" "sonarqube" {
	metadata {
		name      = "sonarqube"
		namespace = kubernetes_namespace.app.metadata[0].name
		labels    = { app = "sonarqube" }
	}

	spec {
		replicas = 1

		selector {
			match_labels = { app = "sonarqube" }
		}

		template {
			metadata {
				labels = { app = "sonarqube" }
			}

			spec {
				container {
					name  = "sonarqube"
					image = "sonarqube:latest"

					env {
						name  = "SONARQUBE_JDBC_USERNAME"
						value = var.sonar_postgres_user
					}
					env {
						name  = "SONARQUBE_JDBC_PASSWORD"
						value = var.sonar_postgres_password
					}
					env {
						name  = "SONARQUBE_JDBC_URL"
						value = "jdbc:postgresql://svc-sonar-postgres:5432/${var.sonar_postgres_db}"
					}

					port {
						container_port = 9000
					}
				}
			}
		}
	}

	depends_on = [
		kubernetes_service.sonarqube,
		kubernetes_deployment.sonar_postgres,
	]
}
