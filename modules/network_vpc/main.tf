
data "aws_availability_zones" "available" {}

resource "aws_vpc" "main"{
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.env}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.env}-igw"
  }
}

resource "aws_subnet" "public_sub" {
  count = length(var.public_subnet_cidr)
  vpc_id = aws_vpc.main.id
  cidr_block = element(var.public_subnet_cidr, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.env}-public-subnet-${count.index + 1}"
  }
} 

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id  = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.env}-route-public_sub"
  }
}
resource "aws_route_table_association" "public_routes" {
  count = length(aws_subnet.public_sub.*.id)
  route_table_id = aws_route_table.public_rt.id
  subnet_id = element(aws_subnet.public_sub.*.id, count.index)
}
#===================================================================================================
resource "aws_eip" "nat_eip" {
  count = length(var.private_subnet_cidr)
  
  tags = {
    Name = "${var.env}-nat-eip-${count.index + 1}"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  count = length(var.private_subnet_cidr)
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id = element(aws_subnet.public_sub.*.id, count.index)
  tags = {
    Name = "${var.env}-nat-gw-${count.index + 1}"
  }
}
#===================================================================================================

resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnet_cidr)
  vpc_id = aws_vpc.main.id
  cidr_block = element(var.private_subnet_cidr, count.index) 
  availability_zone = data.aws_availability_zones.available.names[count.index]
 
  tags = {
    Name = "${var.env}-private-subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "private_rt" {
  count = length(var.private_subnet_cidr)
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw[count.index].id
  }
  tags = {
    Name = "${var.env}-route-private_subnet-${count.index + 1}"
  }
}

resource "aws_route_table_association" "private_routes" {
  count = length(aws_subnet.private_subnet.*.id)
  route_table_id = aws_route_table.private_rt[count.index].id
  subnet_id = element(aws_subnet.private_subnet.*.id, count.index)
}