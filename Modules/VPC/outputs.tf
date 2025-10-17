output "public_subnet_id1a" {
  value = aws_subnet.public_subnets[0].id
}
output "vpc_id" {
  value = aws_vpc.vpc.id
}
output "vpc_cidr" {
  value = aws_vpc.vpc.cidr_block
}
output "private_subnet1" {
  value = aws_subnet.private_subnets[0].id
}
output "private_subnet2" {
  value = aws_subnet.private_subnets[1].id
}
output "private_subnet3" {
  value = aws_subnet.private_subnets[2].id
}