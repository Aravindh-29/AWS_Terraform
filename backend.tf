terraform {
  backend "s3" {
    bucket = "my-terraform-state-16102025"
    key = "networking/terraform.tfstate"
    region = "ap-south-1"
    dynamodb_table = "tf-locks"
    encrypt = true
  }
}