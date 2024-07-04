# Define the AWS EC2 instance for the k3s master node
resource "aws_instance" "exercise_ec2_k3s_master" {
  ami             = data.aws_ami.ubuntu_2004.id
  instance_type   = var.instance_type
  subnet_id       = element(module.vpc.public_subnets, 0)
  key_name        = module.key_pair.key_pair_name
  security_groups = [module.k3s_master_sg.security_group_id]

  user_data = <<-EOF
    #!/bin/bash
    # Update and install necessary packages
    sudo apt-get update -y
    sudo apt-get install -y curl

    # Install kubectl
    sudo curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
    sudo chmod +x ./kubectl
    sudo mv ./kubectl /usr/local/bin/kubectl

    # Install Helm
    sudo curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
    sudo chmod +x get_helm.sh
    sudo ./get_helm.sh

    # Install k3s with cluster initialization
    curl -sfL https://get.k3s.io | K3S_TOKEN=${var.k3s_token} sh -s - server --cluster-init
    EOF

  tags = {
    Name        = "${lower(var.app_name)}-${var.app_environment}-master-server"
    Environment = var.app_environment
  }   
}

# Define the AWS EC2 instance for the k3s worker node
resource "aws_instance" "exercise_ec2_k3s_worker" {
  ami             = data.aws_ami.ubuntu_2004.id
  instance_type   = var.instance_type
  subnet_id       = element(module.vpc.public_subnets, 0)
  key_name        = module.key_pair.key_pair_name
  security_groups = [module.k3s_worker_sg.security_group_id]

  user_data = <<-EOF
    #!/bin/bash
    # Update and install necessary packages
    sudo apt-get update -y
    sudo apt-get install -y curl

    # Install k3s and join the master node
    curl -sfL https://get.k3s.io | K3S_TOKEN=${var.k3s_token} K3S_URL=https://${aws_instance.exercise_ec2_k3s_master.public_ip}:6443 sh -
    EOF

  tags = {
    Name        = "${lower(var.app_name)}-${var.app_environment}-worker-server"
    Environment = var.app_environment
  }   
}
