#Security group for Windows instance
module "win_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.17.2"

  name        = "${lower(var.app_name)}-${var.app_environment}-windows-sg"
  description = "Security group for Windows instance"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["rdp-tcp", "all-icmp"]
  egress_rules        = ["all-all"]

  tags = {
    Name        = "${lower(var.app_name)}-${var.app_environment}-windows-sg"
    Environment = var.app_environment
  }
}

#Security group for K3s Master instance
module "k3s_master_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.17.2"

  name        = "${lower(var.app_name)}-${var.app_environment}-master-sg"
  description = "Security group for K3s Master instance"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["kubernetes-api-tcp","ssh-tcp", "all-icmp"]
  egress_rules        = ["all-all"]

  tags = {
    Name        = "${lower(var.app_name)}-${var.app_environment}-master-sg"
    Environment = var.app_environment
  }
}

#Security group for K3s Worker instance
module "k3s_worker_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.17.2"

  name        = "${lower(var.app_name)}-${var.app_environment}-worker-sg"
  description = "Security group for K3s Worker instance"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["kubernetes-api-tcp","ssh-tcp", "all-icmp"]
  egress_rules        = ["all-all"]

  tags = {
    Name        = "${lower(var.app_name)}-${var.app_environment}-worker-sg"
    Environment = var.app_environment
  }
}