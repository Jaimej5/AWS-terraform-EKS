#datasource para extraer las salidas anteriores del estado de la vpc anterior
#normalmente el remote state se guarda en s3

data "terraform_remote_state" "vpc" {
    backend = "s3"

    config = {
      bucket = "remote-state-bucket-vcc-2021-q1"
      key = "vpc/terraform.tfstate"
      region = "us-east-1"
    }
}