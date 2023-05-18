variable "aws_instance_id" {
  type = string
}

variable "enable_application_load_balancer" {
  type    = bool
  default = true
}

variable "enable_network_load_balancer" {
  type    = bool
  default = true
}

variable "name" {
  type    = string
  default = "lucee"
}

variable "security_group_alb" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}
