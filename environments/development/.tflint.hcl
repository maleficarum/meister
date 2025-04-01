plugin "terraform" {
    enabled = true
    version = "0.12.0"
    source  = "github.com/terraform-linters/tflint-ruleset-terraform"
}

plugin "aws" {
    enabled = true
    version = "0.38.0"
    source  = "github.com/terraform-linters/tflint-ruleset-aws"
}