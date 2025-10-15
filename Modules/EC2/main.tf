resource "aws_instance" "ec2" {
  ami = var.instance.ami # "ami-0e306788ff2473ccb"
  instance_type = var.instance.instance_type #"t3.micro"
  subnet_id = var.subnet_id
  associate_public_ip_address = true
  key_name               =  var.instance.key_name #"Syskey" 

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
  cidr_ipv4 = var.vpc_cidr
  ip_protocol = "tcp"
  from_port = "22"
  to_port = "22"
}
resource "aws_vpc_security_group_ingress_rule" "allow_80" {
  security_group_id = aws_security_group.security_group.id
  cidr_ipv4 = var.vpc_cidr
  ip_protocol = "tcp"
  from_port = "80"
  to_port = "80"
}