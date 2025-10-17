variable "eks_cluster_name" {
  type = string
}

variable "public_subnet1" {
  type = string
}

variable "private_subnet1" {
  type = string
}
variable "private_subnet2" {
  type = string
}
variable "private_subnet3" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "node_group_name" {
  type = string
}
variable "instance_types" {
  type = list(string)
}


variable "tags" {
  type = object({
    Environment = string
    Project     = string
  })
}
