locals {
  name = "lucee"
}

##############################################################
# Module "vpc" is responsible for:
# - creating a VPC, if vpc_id is empty or
# - reading data from the existing VPC, if vpc_id is defined
##############################################################
module "vpc" {
  source = "./modules/vpc"

  name   = local.name
  vpc_id = var.vpc_id
}

##############################################################
# Module "security" is responsible for:
# - creating SSH keypair (used in EC2 later)
# - creating security groups for EC2, ALB and NLB
##############################################################
module "security" {
  source = "./modules/security"

  name              = local.name
  ssh_ingress_rules = var.ssh_ingress_rules
  vpc_cidr_block    = module.vpc.vpc_cidr_block
  vpc_id            = module.vpc.vpc_id
}

##############################################################
# Module "load_balancers" is responsible for:
# - creating application load balancer (http & https)
# - creating network load balancer (ssh)
##############################################################
module "load_balancers" {
  source = "./modules/load_balancers"

  name               = local.name
  security_group_alb = module.security.sg_alb
  subnets            = module.vpc.subnet_ids
  vpc_id             = module.vpc.vpc_id

  aws_instance_id = aws_instance.lucee.id

  enable_application_load_balancer = var.enable_application_load_balancer
  enable_network_load_balancer     = var.enable_network_load_balancer
}

###############################################
# Lucee EC2 running without public IP address
###############################################
resource "aws_instance" "lucee" {
  ami           = var.ami_lucee_id
  instance_type = "t2.small"

  associate_public_ip_address = false
  key_name                    = module.security.ssh_key_name
  subnet_id                   = element(module.vpc.subnet_ids, 0)
  vpc_security_group_ids      = [module.security.sg_ec2, module.security.sg_nlb]

  tags = {
    Name = "${local.name}-alb-ec2"
  }
}
