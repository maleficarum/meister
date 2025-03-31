locals {
    envlocals =  read_terragrunt_config("env.hcl")
    tfvars = jsondecode(read_tfvars_file("variables.tfvars"))
    project = get_env("GCP_PROJECT_ID")

    private_subnet_region = local.tfvars.private_subnet_region
}

generate "terraform" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF

  terraform {
    required_version = ">=1.9.7"
    required_providers {

      google = {
        source  = "hashicorp/google"
        version = "~> 6.27.0"
      }

    }
  }

  provider "google" {
    project = "${local.project}"
    region = "${local.envlocals.locals.region}"
  }

  EOF
}

generate "module" {
  path = "network.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
    module "network" {
      source = ".//network"
      private_subnet_region = "${local.private_subnet_region}"
    }  
    module "kubernetes" {
      source = ".//kubernetes"

      main_network = module.network.main_network.id
      subnetwork = module.network.subnetwork.id
      cluster_location = "TEST"

      depends_on = [module.network]

    }
    
  EOF
}


remote_state {
  backend = "http"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    update_method = "PUT"
    address       = "https://objectstorage.us-phoenix-1.oraclecloud.com/p/CZM27stAvBwo0zvR2zGNDJXtBGuyb7ycaX_qtZipE1BQzH1lgM7kIdiue2Mt6reG/n/idi1o0a010nx/b/terraform-state/o/${path_relative_to_include()}/terraform.tfstate"
  }
}