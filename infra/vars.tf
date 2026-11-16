variable "cluster_name" {
  default = "soat-cluster"
}

variable "namespace" {
  default = "soat-grupo76"
}

variable "serverless_port" {
  default = "3001"
}

variable "client_id"                {}
variable "client_secret"            {}
variable "jwt_secret"               {}
variable "service_order_url"        { default = "http://app-svc-15soat-tech-challenge:3000" }
variable "authorization_server_url" { default = "http://svc-15soat-auth-service:3001" }
variable "stock_service_url"        { default = "http://svc-15soat-stock-update-service:3002" }
variable "status_service_url"       { default = "http://svc-15soat-status-update-service:3003" }
variable "payment_service_url"      { default = "http://svc-15soat-payment-service:3004" }

variable "sonar_postgres_user"      {}
variable "sonar_postgres_password"  {}
variable "sonar_postgres_db"        {}

variable "rabbitmq_user"            {}
variable "rabbitmq_password"        {}
