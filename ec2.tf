# Data Source: Dynamically fetches the latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

# Main EC2 Instance
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public.id

  # Associates the Security Group defined in security.tf
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # Uses the existing key pair defined in variables
  key_name = var.aws_key_name

  # Bootstrapping script
  user_data = file("user_data.sh")

  tags = {
    Name = "${var.project_name}-webserver"
    Role = "Web"
  }
}

# Elastic IP: Ensures a static public IP address (Cost: ~$0.005/hour)
resource "aws_eip" "lb" {
  instance = aws_instance.web_server.id
  domain   = "vpc"

  tags = {
    Name = "${var.project_name}-eip"
  }
}