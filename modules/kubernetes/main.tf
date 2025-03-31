resource "google_container_cluster" "primary" {
  name                     = "primary"
  location                 = var.cluster_location
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = var.main_network
  subnetwork               = var.subnetwork
  networking_mode          = "VPC_NATIVE"

  node_locations = [
    var.cluster_location
  ]

  addons_config {
    http_load_balancing {
      disabled = true
    }

    horizontal_pod_autoscaling {
      disabled = true
    }
  }

  release_channel {
    channel = "REGULAR"
  }

  /*workload_identity_config {
      workload_pool = "value"
    }*/

  ip_allocation_policy {
    cluster_secondary_range_name  = "k8s-pod-range"
    services_secondary_range_name = "k8s-service-range"
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }
}

resource "google_service_account" "kubernetes" {
  account_id = "kubernetes"
}

resource "google_container_node_pool" "general" {
  name       = "general"
  cluster    = google_container_cluster.primary.id
  node_count = 1

  node_config {
    preemptible  = false
    machine_type = "e2-small"

    labels = {
      "role" = "general"
    }

    service_account = google_service_account.kubernetes.email
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]

  }
}

resource "google_container_node_pool" "spot" {
  name    = "spot"
  cluster = google_container_cluster.primary.id

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  autoscaling {
    min_node_count = 0
    max_node_count = 5
  }

  node_config {
    preemptible  = true
    machine_type = "e2-small"

    labels = {
      "team" = "devops"
    }

    taint {
      key    = "instance_type"
      value  = "spot"
      effect = "NO_SCHEDULE"
    }
    service_account = google_service_account.kubernetes.email
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]
  }

}