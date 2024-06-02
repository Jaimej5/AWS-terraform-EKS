#version obsoleta
terraform {
  required_providers {
    kubernetes = {
        source = "hashicorp/kubernetes"
        version = "~> 2.13"
    }
  }
}

#Para acceder a informacion del cluster una vez creado
data "aws_eks_cluster" "cluster" {
    name = module.my-cluster.cluster_id
}

#Auth
data "aws_eks_cluster_auth" "cluster" {
    name = module.my-cluster.cluster_id
}

#Provider de k8s para conectarse a él
provider "kubernetes" {
    host = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token = data.aws_eks_cluster_auth.cluster.token
    #oad_config_file = false
}

module "my-cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.0.0"
  cluster_name = "${var.project_name}-${var.environment}"
  cluster_version = "1.24"
  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
}

resource "aws_eks_node_group" "node_group" {
  cluster_name = module.my-cluster.cluster_id
  node_group_name = "nodes1"
  node_role_arn = aws_iam_role.nodes.arn
  subnet_ids  = data.terraform_remote_state.vpc.outputs.private_subnets
  scaling_config {
    max_size = 5
    min_size = 1
    desired_size = 1
    }
    instance_types = ["t2.micro"]
}