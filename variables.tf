variable "env" {
  description = "Environment tag for resources (e.g. demo, production)"
  type        = string
  default     = "demo"
  validation {
    condition     = contains(["demo", "staging", "production"], var.env)
    error_message = "env must be one of: demo, staging, production."
  }
}

variable "ssh_port" {
  description = "SSH port for the instance"
  type        = number
  default     = 2222
  validation {
    condition     = var.ssh_port >= 1 && var.ssh_port <= 65535
    error_message = "ssh_port must be between 1 and 65535."
  }
}

variable "portainer_port" {
  description = "Portainer port"
  type        = number
  default     = 9443
  validation {
    condition     = var.portainer_port >= 1 && var.portainer_port <= 65535
    error_message = "portainer_port must be between 1 and 65535."
  }
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "allowed_cidr_blocks" {
  description = "Trusted CIDR blocks allowed to access exposed services"
  type        = list(string)
  validation {
    condition     = length(var.allowed_cidr_blocks) > 0
    error_message = "At least one trusted CIDR must be provided in allowed_cidr_blocks."
  }
}

variable "enable_http" {
  description = "Whether to allow HTTP (80) in addition to HTTPS"
  type        = bool
  default     = false
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "public_key_path" {
  description = "Path to your public SSH key"
  type        = string
  default     = "~/.ssh/YOUR_PUBLIC_KEY.pub"
}

variable "ami_id" {
  description = "Ubuntu AMI ID for the EC2 instance (e.g., ami-xxxxxxxx)"
  type        = string
  validation {
    condition     = can(regex("^ami-[0-9a-fA-F]+$", var.ami_id))
    error_message = "ami_id must look like an AMI ID, e.g., ami-0abc1234def567890."
  }
}
