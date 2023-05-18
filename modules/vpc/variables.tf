variable "name" {
  type    = string
  default = "lucee"
}

variable "vpc_id" {
  type    = string
  default = ""

  validation {
    condition     = length(var.vpc_id) == 0 || substr(var.vpc_id, 0, 4) == "vpc-"
    error_message = "The vpc_id value must be a valid VPC, starting with \"vpc-\" or empty"
  }
}
