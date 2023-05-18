output "alb_dns_name" {
  value = var.enable_application_load_balancer ? aws_alb.alb[0].dns_name : ""
}

output "nlb_dns_name" {
  value = var.enable_network_load_balancer ? aws_lb.nlb[0].dns_name : ""
}
