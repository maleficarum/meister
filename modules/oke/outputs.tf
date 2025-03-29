output "api_public_ip" {
  value = oci_containerengine_cluster.challenge-cluster.endpoints[0].public_endpoint
}