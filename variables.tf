variable "aws_region" {
  default = "us-east-1"
}
variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "ami_lucee_id" {
  type = string
}

variable "vpc_id" {
  type    = string
  default = ""

  validation {
    condition     = length(var.vpc_id) == 0 || substr(var.vpc_id, 0, 4) == "vpc-"
    error_message = "The vpc_id value must be a valid VPC, starting with \"vpc-\" or empty"
  }
}

variable "ssh_ingress_rules" {
  type = list(object({
    description = string
    cidr_blocks = list(string)
  }))
}

variable "enable_application_load_balancer" {
  type    = bool
  default = true
}

variable "enable_network_load_balancer" {
  type    = bool
  default = false
}
