locals {
  metrics_server_raw = split("---", file("${path.module}/../k8s/metrics.yml"))

  metrics_server_docs = {
    for doc in local.metrics_server_raw :
    "${yamldecode(doc).kind}-${yamldecode(doc).metadata.name}" => yamldecode(doc)
    if trimspace(doc) != ""
  }
}

resource "kubernetes_manifest" "metrics_server" {
  for_each = local.metrics_server_docs
  manifest = each.value

  depends_on = [kubernetes_namespace.app]
}
