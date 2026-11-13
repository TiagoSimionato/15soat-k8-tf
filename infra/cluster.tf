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
        container_port = 30001
        host_port      = 3001
        protocol       = "TCP"
      }
      extra_port_mappings {
        container_port = 30002
        host_port      = 3002
        protocol       = "TCP"
      }
      extra_port_mappings {
        container_port = 30003
        host_port      = 3003
        protocol       = "TCP"
      }
      extra_port_mappings {
        container_port = 30004
        host_port      = 3004
        protocol       = "TCP"
      }
      extra_port_mappings {
        container_port = 30005
        host_port      = 3005
        protocol       = "TCP"
      }
      extra_port_mappings {
        container_port = 30006
        host_port      = 3006
        protocol       = "TCP"
      }
      extra_port_mappings {
        container_port = 30007
        host_port      = 3007
        protocol       = "TCP"
      }
      extra_port_mappings {
        container_port = 30008
        host_port      = 3008
        protocol       = "TCP"
      }
      extra_port_mappings {
        container_port = 30009
        host_port      = 3009
        protocol       = "TCP"
      }
      extra_port_mappings {
        container_port = 30010
        host_port      = 3010
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
