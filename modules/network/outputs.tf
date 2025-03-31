output "main_network" {
    value = google_compute_network.main_network
}

output "subnetwork" {
    value = google_compute_subnetwork.private
}