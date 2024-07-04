output "ec2_k3s_master_public_ip" {
  value = aws_instance.exercise_ec2_k3s_master.public_ip
  description = "The public IP address of the EC2 K3s Master instance."
}