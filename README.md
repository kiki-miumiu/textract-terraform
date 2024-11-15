# textract-terraform

## Prerequisite

### Terraform State Bucket
```bash
aws s3api create-bucket --bucket terraform-state-061039763240 --create-bucket-configuration LocationConstraint=ap-southeast-2
```

## Usage
```bash
cd terraform
terraform init
```

## Useful information
* [](https://github.com/hashicorp/learn-terraform-lambda-api-gateway/blob/final/main.tf)