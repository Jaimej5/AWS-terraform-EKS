#datasource para extraer las salidas anteriores del estado de la vpc anterior

#normalmente el remote state se guarda en s3 pero lo hacemos desde local para que sea más sencillo

data "terraform_remote_state" "vpc" {
    backend = "local"

    config = {
      path = "../vpc/terraform.tfstate"
    }
}