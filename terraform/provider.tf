# Configure Terraform backend and required providers
terraform {
  backend "s3" {
    bucket  ="terraform-state-061039763240"
    key     = "textract/terraform.tfstate"
    region  = "ap-southeast-2"
  }
  required_version = ">= 1.9.7"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "<= 5.69"
    }
  }
}

# Configure the AWS provider
provider "aws" {
  region = "ap-southeast-2"
}
