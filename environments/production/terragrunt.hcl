include "root" {
  path   = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../..//modules/oke"

  extra_arguments "custom_vars" {
    commands = [
      "apply",
      "plan"
    ]

    required_var_files = ["variables.tfvars"]
  }
}