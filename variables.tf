variable "vpc_cidr" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "internet_gateway_Name" {
  type = string
}

variable "availability_zone" {
  type = list(string)
  default = [ "ap-south-1a","ap-south-1b","ap-south-1c" ]
}


variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}
variable "public_subnet_name" {
  type    = string
  default = "Public_Subnet"
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}
variable "private_subnet_name" {
  type    = string
  default = "Private_Subnet"
}



variable "Public_route_table_Name" {
  type = string
}
variable "public_route_cidr" {
  type = string
}


#----------
variable "instance" {
  type = object({
    name = string
    ami = string
    instance_type = string
    key_name = string
  })
}
variable "security_group_Name" {
  type = string
}

variable "tags" {
  type = object({
    Environment = string
    Project     = string
  })
}
