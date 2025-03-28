locals {
    envlocals =  read_terragrunt_config("env.hcl")

    environment = local.envlocals.locals.environment
}

generate "terraform" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF

  terraform {
    required_version = ">=1.9.7"
    required_providers {
      ansible = {
        version = "~> 1.3.0"
        source  = "ansible/ansible"
      }

      aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
      }

      vault = {
        version = "~> 4.7"
      }
    }
  }

  provider "aws" {
    region = "${local.envlocals.locals.region}"
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