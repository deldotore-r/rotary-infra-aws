#!/bin/bash
# Redirects logs to /var/log/user-data.log for debugging purposes
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

echo "Starting server configuration..."

# 1. System Security Updates
dnf update -y

# 2. Web Server Installation (Nginx)
dnf install -y nginx

# 3. Start and Enable Service
systemctl start nginx
systemctl enable nginx

# 4. Permission Management
# Allows default user (ec2-user) to manage web files
chown -R ec2-user:nginx /usr/share/nginx/html
chmod 2775 /usr/share/nginx/html
find /usr/share/nginx/html -type d -exec chmod 2775 {} \;
find /usr/share/nginx/html -type f -exec chmod 0664 {} \;

# 5. Deploy Test Page
echo "<h1>Rotary Club da Guarda</h1><h3>Infrastructure Provisioned via Terraform</h3><p>Status: Operational</p>" > /usr/share/nginx/html/index.html

echo "Configuration finished."

