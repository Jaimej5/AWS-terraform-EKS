#Este archivo se encarga de configurar el backend de terraform (ya desplegado) para que los archivos de estado se guarden en un bucket de S3
#Activar el versionado de S3 para tener un historial de los archivos de estado y poder recuperar versiones anteriores en caso de ser necesario
#Activar la encriptación de los archivos de estado para proteger la información sensible de usuarios malintencionados

terraform {
  backend "s3" {
    bucket = "remote-state-bucket-vcc-2021-q1"
    key = "vpc/terraform.tfstate"
    region = "us-east-1"
  }
}