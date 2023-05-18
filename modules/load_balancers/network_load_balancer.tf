resource "aws_lb" "nlb" {
  count = var.enable_network_load_balancer ? 1 : 0

  name               = "${var.name}-nlb"
  load_balancer_type = "network"
  subnets            = var.subnets

  tags = {
    Name = "${var.name}-nlb"
  }
}

resource "aws_lb_target_group" "group" {
  count = var.enable_network_load_balancer ? 1 : 0

  name     = "${var.name}-ssh-target-group"
  port     = 22
  protocol = "TCP"
  vpc_id   = var.vpc_id

  health_check {
    protocol = "TCP"
    timeout  = 10
  }

  tags = {
    Name = "${var.name}-ssh-target-group"
  }
}

resource "aws_lb_target_group_attachment" "attachment" {
  count = var.enable_network_load_balancer ? 1 : 0

  target_id        = var.aws_instance_id
  target_group_arn = aws_lb_target_group.group[0].arn
  port             = 22
}

resource "aws_lb_listener" "ssh" {
  count = var.enable_network_load_balancer ? 1 : 0

  load_balancer_arn = aws_lb.nlb[0].arn
  port              = 22
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.group[0].arn
  }

  tags = {
    Name = "${var.name}-nlb-ssh-listener"
  }
}
