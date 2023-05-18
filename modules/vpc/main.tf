locals {
  create_custom_vpc = var.vpc_id == "" ? true : false
}
