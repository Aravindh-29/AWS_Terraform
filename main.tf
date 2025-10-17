module "VPC" {
  source = "./Modules/VPC"

  vpc_cidr = var.vpc_cidr
  vpc_name = var.vpc_name

  internet_gateway_Name = var.internet_gateway_Name

  public_route_cidr       = var.public_route_cidr
  Public_route_table_Name = var.Public_route_table_Name

  availability_zone    = var.availability_zone
  public_subnet_cidrs  = var.public_subnet_cidrs
  public_subnet_name   = var.public_subnet_name
  private_subnet_cidrs = var.private_subnet_cidrs
  private_subnet_name  = var.private_subnet_name

  eks_cluster_name = var.eks_cluster_name

  tags = {
    Environment = var.tags.Environment
    Project     = var.tags.Project
  }
}

module "EC2" {
  source = "./Modules/EC2"
  instance = {
    name          = var.instance.name
    ami           = var.instance.ami
    instance_type = var.instance.instance_type
    key_name      = var.instance.key_name
  }
  vpc_cidr            = module.VPC.vpc_cidr
  vpc_id              = module.VPC.vpc_id
  security_group_Name = var.security_group_Name
  subnet_id           = module.VPC.public_subnet_id1a

  tags = {
    Environment = var.tags.Environment
    Project     = var.tags.Project
  }

  depends_on = [module.VPC]
}

module "ECR" {
  source = "./Modules/ECR"
  ecr = {
    name                 = var.ecr.name
    image_tag_mutability = var.ecr.image_tag_mutability
  }

  depends_on = [module.VPC, module.EC2]
}

module "EKS" {
  source = "./Modules/EKS"

  eks_cluster_name = var.eks_cluster_name
  private_subnet1  = module.VPC.private_subnet1
  private_subnet2  = module.VPC.private_subnet2
  private_subnet3  = module.VPC.private_subnet3
  public_subnet1 = module.VPC.public_subnet_id1a

  vpc_cidr = module.VPC.vpc_cidr
  node_group_name = var.node_group_name
  instance_types  = var.instance_types

  tags = var.tags

  depends_on = [module.VPC, module.EC2, module.ECR]
}