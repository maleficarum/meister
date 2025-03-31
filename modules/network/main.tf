resource "google_project_service" "compute" {
    service = "compute.googleapis.com"
}

resource "google_project_service" "container" {
    service = "container.googleapis.com"
}

resource "google_compute_network" "main_network" {
    name = "main"
    routing_mode = "REGIONAL"
    auto_create_subnetworks = false
    delete_default_routes_on_create = false

    depends_on = [ google_project_service.compute, google_project_service.container ]
}

resource "google_compute_subnetwork" "private" {
    name = "private"
    network = google_compute_network.main_network.id

    ip_cidr_range = "10.0.0.0/16"
    region = var.private_subnet_region

    private_ip_google_access = true

    secondary_ip_range {
      range_name = "k8s-pod-range"
      ip_cidr_range = "10.1.0.0/24"
    }

    secondary_ip_range {
      range_name = "k8s-service-range"
      ip_cidr_range = "10.2.0.0/24"
    }    
}

resource "google_compute_router" "router" {
    name = "router"
    region = var.private_subnet_region
    network = google_compute_network.main_network.id
}

resource "google_compute_address" "nat" {
    name = "nat"
    address_type = "EXTERNAL"
    network_tier = "STANDARD"

    depends_on = [ google_project_service.compute ]
    
}

resource "google_compute_router_nat" "nat" {
    name = "nat"
    router = google_compute_router.router.id
    source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
    region = var.private_subnet_region
    nat_ip_allocate_option = "MANUAL_ONLY"

    subnetwork {
      name = google_compute_subnetwork.private.id
      source_ip_ranges_to_nat = [ "ALL_IP_RANGES" ]
    }

    nat_ips = [ google_compute_address.nat.self_link ]
    
}

resource "google_compute_firewall" "firewall" {
    name = "allow-ssh"
    network = google_compute_network.main_network.id

    allow {
      protocol = "tcp"
      ports = [ "22" ]
    }

    source_ranges = [ "0.0.0.0/0" ]
    
}