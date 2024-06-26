# para acceder a los datasources de terraform_remote_state anteriormente creados (outputs)

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "remote-state-bucket-vcc-2021-q1"
    key    = "vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "remote-state-bucket-vcc-2021-q1"
    key    = "eks/terraform.tfstate"
    region = "us-east-1"
  }
  
}
