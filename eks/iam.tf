#rol de IAM que asumirán los nodos que se vayan creando. Es deciir, los nodos de computación (EC2). Finalmente les añadimos políticas (explicadas abajo)

#Asumible por EC2 (19)

#Política: Terraform crea la politica a partir de un archivo json que se encuentra en la misma carpeta que este archivo.
#La funcion de esta politica es permitir al controlador de balanceadores de carga de AWS interactuar con los recursos de AWS.
resource "aws_iam_policy" "load_ballancer_controller" {
    name = "AmazonEKSLoadBalancerControllerPolicyTF"
    path = "/"
    description = "Policy for Load Ballancer controller on EKS"
    policy = file("iam_policy.json")
}

#rol de IAM: Va a permitir que sololos pods de la cuenta de servicio aws-load-balancer-controller en el espacio de nombres kube-system pueda asumir
# este rol a traves del bloque "principal" y la condicion "Condition" que se encuentra en el archivo json. En vez de dar todos los permisos a todos
#los nodos, se le da permisos a un solo nodo.
resource "aws_iam_role" "load_ballancer_controller" {
    name = "AmazonEKSLoadBalancerControllerRoleTF"
    assume_role_policy = jsonencode({ #jsonencode convierte expresiones de terraform a json
        Version ="2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRoleWithWebIdentity"
                Effect = "Allow"
                Sid = ""
                
                Principal ={
                    Federated = "${module.eks.oidc_provider_arn}"
                }

                "Condition" ={
                    StringEquals = {
                        "${module.eks.oidc_provider_arn}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
                    }
                }
            }
        ]
    })

}

#Añadimos la politica al rol
resource "aws_iam_policy_attachment" "load_ballancer_controller" {
    name = "AmazonEKSLoadBalancerControllerRoleTF"
    roles = [aws_iam_role.load_ballancer_controller.name]
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"  #Las instancias tengan permisos para realizar acciones a través de la red (Kubernetes)
}
