output "api_public_ip" {
  value = oci_containerengine_cluster.challenge_cluster.endpoints[0].public_endpoint
}