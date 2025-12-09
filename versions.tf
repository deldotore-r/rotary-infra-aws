# versions.tf

terraform {
  # Native S3 Locking requires Terraform v1.10+
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    http = {
      source  = "hashicorp/http"
      version = "~> 3.0"
    }
  }


  # UNCOMMENT THIS BLOCK AFTER RUNNING 'terraform apply' FOR THE FIRST TIME
  # ---------------------------------------------------------------------
   backend "s3" {
    # Must match the bucket name created in backend_infra.tf
    bucket = "deldotore-tfstate-native-2025"

    key    = "rotary-infra/terraform.tfstate"
    region = "us-east-1"

    # ENABLES S3 NATIVE LOCKING (No DynamoDB required)
    # Uses S3 conditional writes to prevent concurrent execution
    use_lockfile = true

    encrypt = true
  }
}