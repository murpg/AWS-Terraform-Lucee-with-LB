output "ssh_private_key" {
  value     = module.security.ssh_private_key
  sensitive = true
}

output "ssh" {
  value = {
    host = module.load_balancers.nlb_dns_name
  }
}

output "web" {
  value = {
    http_url   = "http://${module.load_balancers.alb_dns_name}"
    private_ip = aws_instance.lucee.private_ip
  }
}
