terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_key_pair" "example_key" {
  key_name   = "example-aws-key"
  public_key = file(var.public_key_path)

  tags = {
    Name = "example_aws_key"
    env  = var.env
    }
}

resource "aws_security_group" "example_aws_sg" {
  name        = "example-aws-sg"
  description = "Restricted ingress for production"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  ingress {
    description = "Portainer"
    from_port   = var.portainer_port
    to_port     = var.portainer_port
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  dynamic "ingress" {
    for_each = var.enable_http ? [1] : []
    content {
      description = "HTTP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = var.allowed_cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "example_aws_sg"
    env  = var.env
  }
}

resource "aws_instance" "example_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.example_key.key_name
  vpc_security_group_ids = [aws_security_group.example_aws_sg.id]

  user_data = templatefile("${path.module}/user_data.sh.tmpl", {
    ssh_port             = var.ssh_port
    portainer_port       = var.portainer_port
    allowed_cidr_blocks  = join(" ", var.allowed_cidr_blocks)
    enable_http          = var.enable_http
  })

  tags = {
    Name = "example_instance"
    env  = var.env
  }
}
