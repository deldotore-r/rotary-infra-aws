# Data Source: Dynamically fetches the executor's public IP address
# This automation avoids the need to manually update variables when working from home/dynamic IPs
data "http" "my_current_ip" {
  url = "https://ifconfig.me/ip"
}

resource "aws_security_group" "web_sg" {
  name        = "${var.project_name}-sg"
  description = "Traffic control for the web server"
  vpc_id      = aws_vpc.main.id

  # Inbound Rule: HTTP (Port 80) - Public Access
  ingress {
    description = "Public HTTP Access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound Rule: HTTPS (Port 443) - Public Access
  ingress {
    description = "Public HTTPS Access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound Rule: SSH (Port 22) - DYNAMIC RESTRICTION
  # Automatically restricts access to the current public IP of the machine running Terraform
  ingress {
    description = "Administrative SSH Access (Dynamic IP)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    # 'chomp' removes the trailing newline character (\n) from the HTTP response
    # '/32' specifies a single IP address mask
    cidr_blocks = ["${chomp(data.http.my_current_ip.response_body)}/32"]
  }

  # Outbound Rule: Allow all traffic
  # Required for system updates (yum/apt)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-security-group"
  }
}