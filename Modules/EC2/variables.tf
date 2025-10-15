variable "instance" {
  type = object({
    name = string
    ami = string
    instance_type = string
    key_name = string
  })
}

variable "subnet_id" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "vpc_cidr" {
  type = string
}
variable "security_group_Name" {
  type = string
}

variable "tags" {
  type = object({
    Environment = string
    Project = string
  })
}
