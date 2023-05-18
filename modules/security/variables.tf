variable "name" {
  type    = string
  default = "lucee"
}

variable "ssh_ingress_rules" {
  type = list(object({
    description = string
    cidr_blocks = list(string)
  }))
}

variable "vpc_cidr_block" {
  type = string
}

variable "vpc_id" {
  type = string

  validation {
    condition     = length(var.vpc_id) > 4 && substr(var.vpc_id, 0, 4) == "vpc-"
    error_message = "The vpc_id value must be a valid VPC, starting with \"vpc-\"."
  }
}
