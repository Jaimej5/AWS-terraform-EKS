#Para acceder a informacion del cluster una vez creado
data "aws_eks_cluster" "cluster" {
    name = module.eks.cluster_id
}

#Auth
data "aws_eks_cluster_auth" "cluster" {
    name = module.eks.cluster_id
}

#Provider de k8s para conectarse a él
provider "kubernetes" {
    host = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token = data.aws_eks_cluster_auth.cluster.token
}

#Agregamos el recurso de ns de k8s para crear el espacio de nombres fg_developers
resource "kubernetes_namespace" "this" {
  metadata {
    name = "fg-developers"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.0.0"

  #HABILITAR PROVEEDOR DE OIDC
  enable_irsa = true
  
  cluster_name = "${var.project_name}-${var.environment}-vcc-eks-tf"
  cluster_version = "1.24"
  cluster_endpoint_private_access = true #Endpoint al que atacamos para conectarnos al cluster
  cluster_endpoint_public_access = true

  #ubicacion de los workers del datasource
  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  
# Esta regla permite el tráfico entrante al puerto 9443 desde el grupo de seguridad del plano de control, que podría ser necesario si estás 
# utilizando el controlador de balanceador de carga de AWS en tu clúster de Kubernetes.
  node_security_group_additional_rules = {
    ingress_allow_access_from_control_pane = {
      type                          = "ingress"
      protocol                      = "tcp"
      from_port                     = 9443
      to_port                       = 9443
      source_cluster_security_group = true
      description                   = "Allow access from control plane to webhook port of AWS load balancer controller"
    }
  }

#nodos de computación
  eks_managed_node_groups = {
    group1 = {
      desired_capacity = 1
      max_capacity = 3
      min_capacity = 1
      instance_type = "t2.micro"
    }
  }
#los perfiles de fargate son para los pods que no se ejecutan en nodos de computación
  fargate_profiles = {
    fg-developers = {
      name = "fg-developers"
      selectors = [
        {
          namespace = "fg-developers"
          labels    = {} # Esto es un mapa de strings vacío
        }
      ]
      depends_on = [kubernetes_namespace.this] #asegurarte de que el recurso aws_eks_fargate_profile se cree después de que se haya creado el espacio
      #de nombres. Puedes hacer esto utilizando la función depends_on en el recurso aws_eks_fargate_profile
    }
  }

  tags = {
    Environment = "staging"
    Terraform   = "true"
  }
}