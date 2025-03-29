
resource oci_containerengine_cluster challenge-cluster {
  cluster_pod_network_options {
    cni_type = "OCI_VCN_IP_NATIVE"
  }
  compartment_id = var.compartment
  defined_tags = {
    "0-ResourceControl.CreatedAt"        = "2025-03-29T02:39:40.952Z"
    "0-ResourceControl.CreatedBy"        = "oracleidentitycloudservice/oscar.ventura@oracle.com"
    "0-ResourceControl.DeleteResource"   = "WeeklyDeleteResourceYes"
    "0-ResourceControl.KeepResource"     = "Enter the reason to keep it"
    "0-ResourceControl.ShutdownResource" = "NightlyShutdownYes"
    "0-ResourceControl.ShutdownTime"     = "Enter the reason to keep it"
    "0-ResourceControl.Team"             = "To_be_Assigned"
  }
  endpoint_config {
    is_public_ip_enabled = "true"
    nsg_ids = [
    ]
    subnet_id = var.public_subnet
  }
  freeform_tags = {
  }
  image_policy_config {
    is_policy_enabled = "false"
  }
  #kms_key_id = <<Optional value not found in discovery>>
  kubernetes_version = var.kubernetes_version
  name               = var.cluster_name
  options {
    add_ons {
      is_kubernetes_dashboard_enabled = "false"
      is_tiller_enabled               = "false"
    }
    admission_controller_options {
      is_pod_security_policy_enabled = "false"
    }
    ip_families = [
      "IPv4",
    ]
    kubernetes_network_config {
      pods_cidr     = var.pods_cidr
      services_cidr = var.services_cidr
    }
    #open_id_connect_discovery = <<Optional value not found in discovery>>
    #open_id_connect_token_authentication_config = <<Optional value not found in discovery>>
    persistent_volume_config {
      defined_tags = {
      }
      freeform_tags = {
      }
    }
    service_lb_config {
      defined_tags = {
      }
      freeform_tags = {
      }
    }
    service_lb_subnet_ids = [
    ]
  }
  type   = "ENHANCED_CLUSTER"
  vcn_id = var.vcn
}

resource oci_containerengine_node_pool export_pool1 {
  cluster_id     = oci_containerengine_cluster.challenge-cluster.id
  compartment_id = var.compartment
  defined_tags = {
    "0-ResourceControl.CreatedAt"        = "2025-03-29T02:39:42.160Z"
    "0-ResourceControl.CreatedBy"        = "oracleidentitycloudservice/oscar.ventura@oracle.com"
    "0-ResourceControl.DeleteResource"   = "WeeklyDeleteResourceYes"
    "0-ResourceControl.KeepResource"     = "Enter the reason to keep it"
    "0-ResourceControl.ShutdownResource" = "NightlyShutdownYes"
    "0-ResourceControl.ShutdownTime"     = "Enter the reason to keep it"
    "0-ResourceControl.Team"             = "To_be_Assigned"
  }
  freeform_tags = {
  }
  initial_node_labels {
    key   = "name"
    value = "pool1"
  }
  kubernetes_version = "v1.32.1"
  name               = "pool1"
  node_config_details {
    defined_tags = {
    }
    freeform_tags = {
    }
    #is_pv_encryption_in_transit_enabled = <<Optional value not found in discovery>>
    #kms_key_id = <<Optional value not found in discovery>>
    node_pool_pod_network_option_details {
      cni_type          = "OCI_VCN_IP_NATIVE"
      max_pods_per_node = "31"
      pod_nsg_ids = [
      ]
      pod_subnet_ids = [
        var.private_subnet
      ]
    }
    nsg_ids = [
    ]
    placement_configs {
    availability_domain = "IAfA:PHX-AD-1"
      #capacity_reservation_id = <<Optional value not found in discovery>>
      fault_domains = [
      ]
      #preemptible_node_config = <<Optional value not found in discovery>>
      subnet_id = var.private_subnet
    }
    size = "1"
  }
  node_eviction_node_pool_settings {
    eviction_grace_duration              = "PT1H"
    is_force_delete_after_grace_duration = "false"
  }
  node_metadata = {
  }
  node_shape = "VM.Standard.E3.Flex"
  node_shape_config {
    memory_in_gbs = var.shape_config.memory
    ocpus         = var.shape_config.ocpus
  }
  node_source_details {
    #boot_volume_size_in_gbs = <<Optional value not found in discovery>>
    image_id    = "ocid1.image.oc1.phx.aaaaaaaak36p3gcd7m5fypfs5j5flxaqxykon4dkjqd3j45zkq57cq52ovoq"
    source_type = "IMAGE"
  }
  #quantity_per_subnet = <<Optional value not found in discovery>>
  #ssh_public_key = <<Optional value not found in discovery>>
  #subnet_ids = <<Optional value not found in discovery>>
}

resource oci_containerengine_addon challenge-cluster_addon {
  addon_name = "CoreDNS"
  cluster_id = oci_containerengine_cluster.challenge-cluster.id
  #override_existing = <<Optional value not found in discovery>>
  remove_addon_resources_on_delete = "true"
  #version = <<Optional value not found in discovery>>
}

resource oci_containerengine_addon challenge-cluster_addon_1 {
  addon_name = "KubeProxy"
  cluster_id = oci_containerengine_cluster.challenge-cluster.id
  #override_existing = <<Optional value not found in discovery>>
  remove_addon_resources_on_delete = "true"
  #version = <<Optional value not found in discovery>>
}

resource oci_containerengine_addon challenge-cluster_addon_2 {
  addon_name = "NvidiaGpuPlugin"
  cluster_id = oci_containerengine_cluster.challenge-cluster.id
  #override_existing = <<Optional value not found in discovery>>
  remove_addon_resources_on_delete = "true"
  #version = <<Optional value not found in discovery>>
}

resource oci_containerengine_addon challenge-cluster_addon_3 {
  addon_name = "OciVcnIpNative"
  cluster_id = oci_containerengine_cluster.challenge-cluster.id
  #override_existing = <<Optional value not found in discovery>>
  remove_addon_resources_on_delete = "true"
  #version = <<Optional value not found in discovery>>
}

