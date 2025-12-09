variable "aws_region" {
  description = "AWS Region where resources will be provisioned (Default: Ireland)"
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project prefix for resource naming and tagging"
  default     = "rotary-guarda"
}

variable "instance_type" {
  description = "EC2 Instance Type (t3.micro is Free Tier eligible in some regions)"
  default     = "t3.micro"
}

variable "aws_key_name" {
  description = "Name of the existing AWS Key Pair for SSH access"
  type        = string
}

# NOTE: The 'my_ip' variable was removed as it is now dynamically fetched in security.tf
