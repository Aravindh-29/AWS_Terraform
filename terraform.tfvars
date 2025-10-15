vpc_cidr = "10.0.0.0/16"
vpc_name = "VPC-Demo"

internet_gateway_Name = "Demo-Internet"

availability_zone   = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
public_subnet_name  = "Public_Subnet"
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

private_subnet_name  = "Private_Subnet"
private_subnet_cidrs = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

Public_route_table_Name = "Public_route_table"
public_route_cidr       = "0.0.0.0/0"

instance = {

  ami           = "ami-0e306788ff2473ccb"
  name          = "WebServer"
  key_name      = "Syskey"
  instance_type = "t3.micro"
}

security_group_Name = "Demo-Securitygroup"


ecr = {
  name                 = "demo_ecr"
  image_tag_mutability = "IMMUTABLE"
}

tags = {
  Environment = "Dev"
  Project     = "DbConTester"
}