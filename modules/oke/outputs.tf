output "api_public_ip" {
  value = oci_containerengine_cluster.oci_containerengine_cluster.endpoints[0].public_endpoint
}