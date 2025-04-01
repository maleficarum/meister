locals {
    envlocals =  read_terragrunt_config("env.hcl")
    tfvars = jsondecode(read_tfvars_file("variables.tfvars"))

    environment = local.envlocals.locals.environment
}

generate "terraform" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF

  terraform {
    required_version = ">=1.9.7"
    required_providers {

      aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
      }

    }
  }

  provider "aws" {
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

      cidr_block = "${local.tfvars.cidr_block}"
      public-cidr_block_1 = "${local.tfvars.public-cidr_block_1}"
      public-cidr_block_2 = "${local.tfvars.public-cidr_block_2}"

    }  
    module "container" {
      source = ".//container"

      ecs_cluster_name = "${local.tfvars.ecs_cluster_name}"
      public_subnet_1 = module.network.public_subnet_1.id
      public_subnet_2 = module.network.public_subnet_2.id
      ecs_tasks = module.network.ecs_tasks.id
      target_group_arn = module.network.target_group_arn.arn
      
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