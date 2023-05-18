resource "aws_alb" "alb" {
  count = var.enable_application_load_balancer ? 1 : 0

  name            = "${var.name}-alb"
  security_groups = [var.security_group_alb]
  subnets         = var.subnets

  tags = {
    Name = "${var.name}-alb"
  }
}

resource "aws_alb_target_group" "group" {
  count = var.enable_application_load_balancer ? 1 : 0

  name       = "${var.name}-http-target-group"
  port       = 80
  protocol   = "HTTP"
  slow_start = 30
  vpc_id     = var.vpc_id

  health_check {
    path     = "/healthcheck"
    port     = 80
    protocol = "HTTP"
    timeout  = 15
    matcher  = "200"
  }

  tags = {
    Name = "${var.name}-http-target-group"
  }
}

resource "aws_alb_target_group_attachment" "attachment" {
  count = var.enable_application_load_balancer ? 1 : 0

  target_id        = var.aws_instance_id
  target_group_arn = aws_alb_target_group.group[0].arn
  port             = 80
}

resource "aws_alb_listener" "http" {
  count = var.enable_application_load_balancer ? 1 : 0

  load_balancer_arn = aws_alb.alb[0].arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.group[0].arn
  }

  tags = {
    Name = "${var.name}-alb-http-listener"
  }
}
