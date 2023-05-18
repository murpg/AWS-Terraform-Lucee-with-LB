data "aws_vpc" "vpc" {
  count = local.create_custom_vpc ? 0 : 1

  id = var.vpc_id
}

data "aws_subnets" "all" {
  count = local.create_custom_vpc ? 0 : 1

  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

resource "random_shuffle" "subnets" {
  count = local.create_custom_vpc ? 0 : 1

  input        = data.aws_subnets.all[0].ids
  result_count = 2
}
