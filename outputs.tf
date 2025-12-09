output "server_public_ip" {
  description = "Public IP address of the web server"
  value       = aws_eip.lb.public_ip
}

output "website_url" {
  description = "Direct URL to access the website"
  value       = "http://${aws_eip.lb.public_ip}"
}

output "ssh_connection_string" {
  description = "Suggested SSH connection command"
  value       = "ssh -i ~/.ssh/${var.aws_key_name}.pem ec2-user@${aws_eip.lb.public_ip}"
}
