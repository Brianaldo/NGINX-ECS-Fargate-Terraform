provider "aws" {
  shared_credentials_files = var.path_to_credentials_file
  profile                  = var.credential_profile
  region                   = var.aws_region
}
