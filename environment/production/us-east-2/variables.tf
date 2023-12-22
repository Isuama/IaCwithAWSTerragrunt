variable "env" {
    description = "Environment Name"
    type = string
}

variable "main_vpc_cidr" {
    description = "Main VPC"
  #default = "10.100.0.0/16"
}

variable "public_subnets" {
    description = "Public Subnet CIDRs"
}
variable public_subnet_tags{
  description = "Tags for the public subnet"
}

variable "private_subnets" {
  description = "Private Subnet CIDRs"
}

variable private_subnet_tags{
  description = "Tags for the private subnet"
}

variable "azs" {
  description = "Availability Zones"
}