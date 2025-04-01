include "env" {
  path = "./env.hcl"
  expose = true
  merge_strategy = "no_merge"
}

include "root" {
  path   = find_in_parent_folders("root.hcl")
}

locals {
  //debug = run_cmd("echo", "${jsonencode(include.env)}")
}

terraform {
  source = "../../..//modules/network"

  before_hook "tflint" {
    commands     = ["apply", "plan"]
    execute      = ["tflint"]
  }

  extra_arguments "custom_vars" {
    commands = [
      "apply",
      "plan"
    ]

    required_var_files = ["variables.tfvars"]
  }
}
/*
inputs = {
  cidr_block = "${include.env.locals.cidr_block}"
  public_cidr_block_1 = "${include.env.locals.public_cidr_block_1}"
  public_cidr_block_2 = "${include.env.locals.public_cidr_block_2}"
}

generate "module" {
  path = "network.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
    module "network" {
      source = "./modules//network"
      
    }
    
  EOF
}
*/
remote_state {
  backend = "http"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    update_method = "PUT"
    address       = "https://objectstorage.us-phoenix-1.oraclecloud.com/p/CZM27stAvBwo0zvR2zGNDJXtBGuyb7ycaX_qtZipE1BQzH1lgM7kIdiue2Mt6reG/n/idi1o0a010nx/b/terraform-state/o/${path_relative_to_include("root")}/network/terraform.tfstate"
  }
}