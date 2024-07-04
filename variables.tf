variable "app_name" {
  type        = string
  description = "Application name"
  default     = "om2"
}

variable "app_environment" {
  type        = string
  description = "Application environment"
  default     = "test"
}

variable "aws_region" {
  type = string
  description = "AWS region"
  default = "eu-west-1"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type        = string
  description = "CIDR for the public subnet"
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  type        = string
  description = "Default EC2 instance type"
  default     = "t3.medium"
}

variable "windows_root_volume_size" {
  type        = number
  description = "Root Volume size for Windows Server"
  default     = "50"
}

variable "windows_data_volume_size" {
  type        = number
  description = "Extra Volume size for Windows Server"
  default     = "10"
}

variable "windows_root_volume_type" {
  type        = string
  description = "Root Volume type"
  default     = "gp2"
}

variable "windows_data_volume_type" {
  type        = string
  description = "Extra Volume type"
  default     = "gp2"
}

variable "k3s_token" {
  type        = string
  description = "K3s Token"
}