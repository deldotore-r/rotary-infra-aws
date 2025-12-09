# backend_infra.tf

# S3 Bucket to store Terraform State remotely
# This replaces the local terraform.tfstate file
resource "aws_s3_bucket" "terraform_state" {
  # Unique bucket name (change "native-2025" if taken)
  bucket = "deldotore-tfstate-native-2025"

  # PREVENTS ACCIDENTAL DELETION
  # This setting is critical for state buckets. It prevents 'terraform destroy'
  # from deleting this bucket, which would lose your infrastructure state.
  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = "Terraform State Storage"
    Environment = "Management"
  }
}

# Enables Versioning on the Bucket
# Crucial for rolling back state in case of corruption or accidental overwrites
resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enforces Server-Side Encryption (SSE) by default
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}