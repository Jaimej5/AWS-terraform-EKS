#Exportamos/consumimos las outputs ddel modulo VPC (recursos)

output "vpc_id" {
    value = module.vpc.vpc_id
}
output private_subnets {
  value =  module.vpc.private_subnets
}