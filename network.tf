# Data source to fetch all available AWS availability zones in the current region
data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name = "${lower(var.app_name)}-${lower(var.app_environment)}-vpc"
  cidr = var.vpc_cidr

  # Use the first three AWS availability zones for creating public subnets
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)

  public_subnets          = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 48)]
  enable_dns_hostnames    = true
  enable_dns_support      = true
  map_public_ip_on_launch = true

  vpc_tags = {
    Name = "${lower(var.app_name)}-${lower(var.app_environment)}-vpc"
  }

  public_subnet_tags = {
    Name = "${lower(var.app_name)}-${lower(var.app_environment)}-public-subnet"
  }
}
