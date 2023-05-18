output "subnet_ids" {
  value = (var.vpc_id == "" ?
    tolist([aws_subnet.zone_one[0].id, aws_subnet.zone_two[0].id])
    :
    random_shuffle.subnets[0].result
  )
}

output "vpc_id" {
  value = (var.vpc_id == "" ?
    aws_vpc.vpc[0].id
    :
    data.aws_vpc.vpc[0].id
  )
}

output "vpc_cidr_block" {
  value = (var.vpc_id == "" ?
    aws_vpc.vpc[0].cidr_block
    :
    data.aws_vpc.vpc[0].cidr_block
  )
}
