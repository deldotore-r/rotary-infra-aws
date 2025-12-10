# 🚀 Project: AWS Self-Healing Web Server (Basic IaC)

### Rotary Club Da Guarda Website Deployment

This project demonstrates the core competencies required for Cloud and DevOps engineering: provisioning secure networking, managing immutable infrastructure, and implementing remote state management using Terraform.

---

## ✨ Architecture & Scope

This infrastructure was provisioned entirely via Terraform in the `us-east-1` (N. Virginia) AWS region.



### Components Provisioned:

* **VPC (10.0.0.0/16):** Network isolation for the entire environment.
* **Internet Gateway (IGW) & Public Subnet:** Enables external internet access for the web server.
* **Security Group:** Implements strict firewall rules:
    * **Inbound 22 (SSH):** Restricted dynamically to the administrator's **current public IP address**. (Automated via `data "http"`).
    * **Inbound 80/443 (HTTP/S):** Open to the world (`0.0.0.0/0`).
* **EC2 Instance (t3.micro):** Serves the Nginx web application.
* **Elastic IP (EIP):** Ensures a fixed public address for the website, independent of instance recreation.

---

## 🛠️ Key Technologies & Best Practices

| Technology | Purpose |
| :--- | :--- |
| **AWS** | VPC, EC2, S3, EIP |
| **Terraform** | Infrastructure as Code (IaC) |
| **Backend Management** | **S3 Native Locking** (`use_lockfile = true`) |
| **Deployment Method** | Bootstrapping (`user_data.sh`) with `git clone` |
| **Security Principle** | Least Privilege (Restricting SSH access dynamically) |

---

## 📝 Bootstrapping & Deployment Workflow

This project follows a professional **Bootstrapping** workflow to manage the remote state:

1.  **State Backend Creation:** The code creates the S3 bucket required for remote state storage (S3 Versioning and Encryption are enabled).
2.  **Infrastructure Creation:** Terraform provisions the networking and EC2 resources.
3.  **Deployment:** The `user_data.sh` script runs automatically on the EC2 instance to install Nginx and deploy the website content via `git clone`.

### Command to Deploy:

```bash
# This command runs the full infrastructure creation and deployment:
terraform apply -var="aws_key_name=YOUR_KEY_NAME"
