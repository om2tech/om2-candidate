# Generate a secure private key and encode it as PEM
module "key_pair" {
  source = "squareops/keypair/aws"
  key_name           = "${lower(var.app_name)}-${lower(var.app_environment)}-windows-${lower(var.aws_region)}"
  environment        = "test"
  ssm_parameter_path = "test-exercise-om2-key"
}

