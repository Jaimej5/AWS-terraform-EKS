#rol de IAM que asumirán los nodos que se vayan creando. Es deciir, los nodos de computación (EC2). Finalmente les añadimos políticas (explicadas abajo)

#Asumible por EC2 (19)
resource "aws_iam_instance_profile" "nodes_profile" {
    name = "${var.project_name}-${var.environment}"
    role = aws_iam_role.nodes.name  
}

#rol de IAM
resource "aws_iam_role" "nodes" {
    name = "${var.project_name}-${var.environment}"
    assume_role_policy =  <<EOF
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Action": "sts:AssumeRole",
                "Principal": {
                    "Service": "ec2.amazonaws.com" 
                },
                "Effect": "Allow",
                "Sid": ""
            }
        ]
    }
    EOF

}

resource "aws_iam_policy_attachment" "attachment1" {
    name = "attachment1"
    roles = [aws_iam_role.nodes.name]
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"  #Las instancias tengan permisos para realizar acciones a través de la red (Kubernetes)
}

resource "aws_iam_policy_attachment" "attachment2" {
    name = "attachment2"
    roles = [aws_iam_role.nodes.name]
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"  #Permiso de solo lectura al registro de imagenes de EC2
}

resource "aws_iam_policy_attachment" "attachment3" {
    name = "attachment3"
    roles = [aws_iam_role.nodes.name]
    policy_arn = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess" #Acceso completo a balanceadores de carga
}

resource "aws_iam_policy_attachment" "attachment4" {
    name = "attachment4"
    roles = [aws_iam_role.nodes.name]
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy" #Accede a subnets, volúmenes, información del cluster...
}