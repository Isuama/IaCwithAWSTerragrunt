variable "main_vpc_cidr" {
    description = "Main VPC"
  #default = "10.100.0.0/16"
}

variable "public_subnet_cidr" {
    description = "Public Subnet CIDR"
  #default = "10.100.2.0/24"
}

variable "private_subnet_cidr" {
  description = "Private Subnet CIDR"
  #default = "10.100.3.0/24"
}

variable "region_location" {
  description = "Selected Region"
}