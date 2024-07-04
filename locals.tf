# Select the first three AWS availability zones
locals {
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)
}