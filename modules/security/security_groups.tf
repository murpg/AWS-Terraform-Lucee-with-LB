resource "aws_security_group" "ec2" {
  name        = "Lucee EC2 (80)"
  description = "Allows inbound traffic for port 80"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allows inbound traffic on port 80."
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allows all outbound traffic."
  }

  tags = {
    Name = "${var.name}_ec2-sg"
  }
}

resource "aws_security_group" "alb" {
  name        = "Lucee ALB (80)"
  description = "Allows inbound traffic for port 80"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allows inbound traffic on port 80 (HTTP)."
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.ec2.id]
    description     = "Allows all outbound traffic to EC2 security group."
  }

  tags = {
    Name = "${var.name}_alb-sg"
  }
}

resource "aws_security_group" "nlb" {
  name        = "Lucee EC2 NLB (22)"
  description = "Allows inbound traffic for port 22"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ssh_ingress_rules
    content {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ingress.value.cidr_blocks
      description = ingress.value.description
    }
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
    description = "Allows traffic for NLB health checks."
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.ec2.id]
    description     = "Allows all outbound traffic to EC2 security group."
  }

  tags = {
    Name = "${var.name}_ec2-nlb-sg"
  }
}

