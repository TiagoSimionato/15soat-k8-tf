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
variable "authorization_server_url" { default = "http://svc-15soat-auth-service:3001" }
