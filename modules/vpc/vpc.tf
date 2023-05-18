resource "aws_vpc" "vpc" {
  count = local.create_custom_vpc ? 1 : 0

  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.name
  }
}

resource "aws_internet_gateway" "gateway" {
  count = local.create_custom_vpc ? 1 : 0

  vpc_id = aws_vpc.vpc[0].id

  tags = {
    Name = "${var.name}-ig"
  }
}

resource "aws_route" "route" {
  count = local.create_custom_vpc ? 1 : 0

  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gateway[0].id
  route_table_id         = aws_vpc.vpc[0].main_route_table_id
}

resource "aws_subnet" "zone_one" {
  count = local.create_custom_vpc ? 1 : 0

  availability_zone = random_shuffle.availability_zones[0].result[0]
  cidr_block        = "10.0.1.0/24"
  vpc_id            = aws_vpc.vpc[0].id

  tags = {
    Name = "${var.name}_zone-one"
  }
}

resource "aws_subnet" "zone_two" {
  count = local.create_custom_vpc ? 1 : 0

  availability_zone = random_shuffle.availability_zones[0].result[1]
  cidr_block        = "10.0.2.0/24"
  vpc_id            = aws_vpc.vpc[0].id

  tags = {
    Name = "${var.name}_zone-two"
  }
}

data "aws_availability_zones" "all" {
  count = local.create_custom_vpc ? 1 : 0
}

resource "random_shuffle" "availability_zones" {
  count = local.create_custom_vpc ? 1 : 0

  input        = data.aws_availability_zones.all[0].names
  result_count = 2
}

