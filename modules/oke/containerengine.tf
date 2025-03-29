resource "oci_containerengine_cluster" "oci_containerengine_cluster" {
	cluster_pod_network_options {
		cni_type = "OCI_VCN_IP_NATIVE"
	}
	compartment_id = var.compartment
	endpoint_config {
		is_public_ip_enabled = "true"
		subnet_id = var.public_subnet
	}
	kubernetes_version = "v1.32.1"
	name = var.cluster_name
	options {
		kubernetes_network_config {
			services_cidr = var.services_cidr
		}
		persistent_volume_config {
		}
		service_lb_config {
		}
	}
	type = "ENHANCED_CLUSTER"
	vcn_id = var.vcn
}

resource "oci_containerengine_node_pool" "node_pool" {
	cluster_id = "${oci_containerengine_cluster.oci_containerengine_cluster.id}"
	compartment_id = var.compartment
	initial_node_labels {
		key = "name"
		value = "pool1"
	}
	kubernetes_version = "v1.32.1"
	name = "pool1"
	node_config_details {
		node_pool_pod_network_option_details {
			cni_type = "OCI_VCN_IP_NATIVE"
			max_pods_per_node = "31"
			pod_subnet_ids = [var.private_subnet]
		}
		placement_configs {
			availability_domain = "IAfA:PHX-AD-1"
			subnet_id = var.private_subnet
		}
		size = "1"
	}
	node_eviction_node_pool_settings {
		eviction_grace_duration = "PT60M"
		is_force_delete_after_grace_duration = "false"
	}
	node_shape = "VM.Standard.E3.Flex"
	node_shape_config {
		memory_in_gbs = var.shape_config.memory
		ocpus = var.shape_config.ocpus
	}
	node_source_details {
		image_id = "ocid1.image.oc1.phx.aaaaaaaak36p3gcd7m5fypfs5j5flxaqxykon4dkjqd3j45zkq57cq52ovoq"
		source_type = "IMAGE"
	}
}
