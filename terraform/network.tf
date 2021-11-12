# network.tf | Network Configuration

resource "aws_vpc" "observer" {
    cidr_block              = var.vpc_cidr_block
    enable_dns_hostnames    = var.vpc_dns_hostnames
    enable_dns_support      = var.vpc_dns_support

    tags = {
        Name        = "${var.app_name}-vpc"
    }
}

resource "aws_internet_gateway" "observer" {
    vpc_id = aws_vpc.observer.id
    
    tags = {
        Name        = "${var.app_name}-igw"
    }
}

resource "aws_nat_gateway" "observer" {
  count         = length(var.private_subnets)
  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  depends_on    = [aws_internet_gateway.observer]

  tags = {
    Name        = "${var.app_name}-ngw"
  }
}

resource "aws_eip" "nat" {
  count = length(var.private_subnets)
  vpc = true

  tags = {
    Name        = "${var.app_name}-eip"
  }
}




resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.observer.id
  count             = length(var.private_subnets)
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name        = "${var.app_name}-private_subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.observer.id
  count                   = length(var.public_subnets)
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.app_name}-public_subnet-${count.index + 1}"
  }
}




resource "aws_route_table" "public" {
  vpc_id = aws_vpc.observer.id

  tags = {
    Name        = "${var.app_name}-route_table-public"
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.observer.id
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}




resource "aws_route_table" "private" {
  count  = length(var.private_subnets)
  vpc_id = aws_vpc.observer.id

  tags = {
    Name        = "${var.app_name}-route_table-private"
  }
}

resource "aws_route" "private" {
  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.observer.*.id, count.index)
  count                  = length(compact(var.private_subnets))
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}


output "id" {
  value = aws_vpc.observer.id
}

output "public_subnets" {
  value = aws_subnet.public
}

output "private_subnets" {
  value = aws_subnet.private
}