terraform {
  backend "s3" {
    bucket = "remote-state-bucket-vcc-2021-q1"
    key = "k8s-utils/terraform.tfstate"
    region = "us-east-1"
  }
}