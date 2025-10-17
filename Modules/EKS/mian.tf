#----------IAM Role For EKS Cluster-------
resource "aws_iam_role" "eks_cluster_role" {
  name = "eksClusterRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name

  depends_on = [aws_iam_role.eks_cluster_role]
}

#---------EKS Cluster------------
resource "aws_eks_cluster" "eks_cluster" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = [
      var.private_subnet1,
      var.private_subnet2,
      var.private_subnet3,
      var.public_subnet1
    ]

    endpoint_public_access  = false
    endpoint_private_access = true
  }

  tags = merge(var.tags)
  depends_on = [aws_iam_role.eks_cluster_role]
}

#------------IAM Role for Node Groups-----------
resource "aws_iam_role" "eks_node_role" {
  name = "eksNodeRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role.name
}

# ---------------- Node Group ----------------
resource "aws_eks_node_group" "eks_nodes" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = [var.private_subnet1, var.private_subnet2, var.private_subnet3]

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 1
  }

  instance_types = var.instance_types

  tags = merge(var.tags)

  depends_on = [
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryReadOnly,
    aws_eks_cluster.eks_cluster
  ]
}

# ---------------- Security Group Rule for Control Plane ----------------
# Fetch the EKS cluster info to get the auto-created control plane SG
data "aws_eks_cluster" "eks" {
  name = aws_eks_cluster.eks_cluster.name
}

# Get the control plane security group
data "aws_security_group" "eks_cluster_sg" {
  id = data.aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id
}

# Allow VPC CIDR to access EKS API server on port 443
resource "aws_vpc_security_group_ingress_rule" "allow_vpc_to_eks_controlplane" {
  security_group_id = data.aws_security_group.eks_cluster_sg.id
  cidr_ipv4         = var.vpc_cidr
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}
