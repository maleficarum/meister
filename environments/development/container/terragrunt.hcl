include "env" {
  path = "env.hcl"
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
  source = "../../..//modules/container"

  before_hook "tflint" {
    commands     = ["apply", "plan"]
    execute      = ["tflint"]
  }

  extra_arguments "custom_vars" {
    commands = [
      "apply",
      "plan",
      "destroy"
    ]

    required_var_files = ["variables.tfvars"]
  }
}

inputs = {
  ecs_cluster_name = "${include.env.locals.ecs_cluster_name}"

  public_subnet_1 = dependency.network.outputs.public_subnet_1.id
  public_subnet_2 = dependency.network.outputs.public_subnet_2.id
  ecs_tasks = dependency.network.outputs.ecs_tasks.id
  target_group_arn = dependency.network.outputs.target_group_arn.arn  
}
/*
generate "module" {
  path = "container.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
    module "container" {
      source = "./modules//container"
      
      depends_on = [module.network]

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
    address       = "https://objectstorage.us-phoenix-1.oraclecloud.com/p/CZM27stAvBwo0zvR2zGNDJXtBGuyb7ycaX_qtZipE1BQzH1lgM7kIdiue2Mt6reG/n/idi1o0a010nx/b/terraform-state/o/${path_relative_to_include("root")}/container/terraform.tfstate"
  }
}

dependency "network" {
  config_path = "../network"
  mock_outputs = {
    public_subnet_1 = { id = ""}
    public_subnet_2 = { id = ""}    
    ecs_tasks = { id = ""}
    target_group_arn = { arn = ""}
  }  
}