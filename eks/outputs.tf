output "load_balancer_controller_iam_role_arn" {
  value = aws_iam_role.load_ballancer_controller.arn
}

output "cluster_id" {
  value = module.eks.cluster_id
}

#proveedor de OIDC
output "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider"
  value       = module.eks.oidc_provider_arn
}