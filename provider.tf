# AWS Provider Configuration
provider "aws" {
  region = var.aws_region

  # Explicitly defines which local credentials profile to use.
  # This prevents accidental deployment to the 'default' or wrong account.
  profile = "reinaldo2"
}
