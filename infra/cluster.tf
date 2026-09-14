resource "kind_cluster" "main" {
  name            = var.cluster_name
  wait_for_ready  = true

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"
      kubeadm_config_patches = [
        <<-EOT
        kind: InitConfiguration
        nodeRegistration:
          kubeletExtraArgs:
            node-labels: "ingress-ready=true"
        EOT
      ]
      extra_port_mappings {
        container_port = 30000
        host_port      = 3000
        protocol       = "TCP"
      }
      extra_port_mappings {
        container_port = 30080
        host_port      = 8000
        protocol       = "TCP"
      }
      extra_port_mappings {
        container_port = 30900
        host_port      = 9000
        protocol       = "TCP"
      }
    }

    node {
      role = "worker"
    }
  }
}
