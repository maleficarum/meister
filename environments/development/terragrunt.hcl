include "root" {
  path   = find_in_parent_folders("root.hcl")
  
  //custom_vars = 
}

terraform {
  source = "../..//modules"

  //set_environment = run_cmd("export", "TG_VAR_FILE=variables.tfvars")

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