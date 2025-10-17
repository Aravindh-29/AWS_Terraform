resource "aws_instance" "ec2" {
  ami = var.instance.ami # "ami-0e306788ff2473ccb"
  instance_type = var.instance.instance_type #"t3.micro"
  subnet_id = var.subnet_id
  associate_public_ip_address = true
  key_name               =  var.instance.key_name #"Syskey" 

  vpc_security_group_ids = [ aws_security_group.security_group.id ]

 tags = merge(var.tags,{
    Name = var.instance.name
 })

 depends_on = [ aws_security_group.security_group ]
}

resource "aws_security_group" "security_group" {
  vpc_id = var.vpc_id

  tags = merge(var.tags,{
    Name = var.security_group_Name
  })
}


resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.security_group.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port = "22"
  to_port = "22"
}
resource "aws_vpc_security_group_ingress_rule" "allow_80" {
  security_group_id = aws_security_group.security_group.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port = "80"
  to_port = "80"
}
resource "aws_vpc_security_group_ingress_rule" "allow_eks_control_plane" {
  security_group_id = aws_security_group.security_group.id
  cidr_ipv4         = var.vpc_cidr
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_kubelet" {
  security_group_id = aws_security_group.security_group.id
  cidr_ipv4         = var.vpc_cidr
  ip_protocol       = "tcp"
  from_port         = 10250
  to_port           = 10250
}

resource "aws_vpc_security_group_egress_rule" "allow_all_egress" {
  security_group_id = aws_security_group.security_group.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}
