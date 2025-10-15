resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr # "10.0.0.0/16"

  tags = merge(var.tags,{
    Name = var.vpc_name # "Demo-VPC"
  })
}


resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(var.tags,{
    Name = var.internet_gateway_Name
  })

  depends_on = [ aws_vpc.vpc ]
}

resource "aws_subnet" "public_subnets" {

  count = length(var.public_subnet_cidrs)
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.public_subnet_cidrs[count.index]
  availability_zone = var.availability_zone[count.index]

  tags = merge(var.tags,{
    Name = "${var.public_subnet_name}-${count.index +1}"
  })


  depends_on = [ aws_vpc.vpc ]
}

resource "aws_subnet" "private_subnets" {

  count = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zone[count.index]
  
  tags = merge(var.tags,{
    Name = "${var.private_subnet_name}-${count.index +1}"
  })


  depends_on = [ aws_vpc.vpc ]
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = merge(var.tags,{
    Name = var.Public_route_table_Name
  })

  depends_on = [ aws_vpc.vpc, aws_internet_gateway.internet_gateway ]
}

resource "aws_route_table_association" "public_rt_association_1a" {
  count = length(var.public_subnet_cidrs)
  route_table_id = aws_route_table.public_route_table.id

  subnet_id = aws_subnet.public_subnets[count.index].id

  depends_on = [ aws_subnet.public_subnets,aws_route_table.public_route_table ]

}