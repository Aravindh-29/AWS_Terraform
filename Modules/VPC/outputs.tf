output "public_subnet_id1a" {
  value = aws_subnet.public_subnets[0].id
}
output "vpc_id" {
  value = aws_vpc.vpc.id
}
output "vpc_cidr" {
  value = aws_vpc.vpc.cidr_block
}