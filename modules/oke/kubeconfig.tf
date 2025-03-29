variable "cluster_kube_config_token_version" {
  default = "2.0.0"
}

data "oci_containerengine_cluster_kube_config" "kubeconfig" {
  cluster_id = oci_containerengine_cluster.challenge_cluster.id

  #Optional
  token_version = var.cluster_kube_config_token_version
}

resource "local_file" "kubecofig_file" {
  content  = data.oci_containerengine_cluster_kube_config.kubeconfig.content
  filename = pathexpand("~/.kubeconfig/kubeconfig.challenge")
}