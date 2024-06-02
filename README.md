# Desplegamos una VPC y EKS en AWS usando TERRAFORM con el mínimo esfuerzo
- Capa pública: Control plane (aunque lo verdaderamente correcto es tenerlo en la capa privada y acceder a el mediante una maquina de salto en la red publica o una VPN)
- Capa privada: Workers (nodos del cluster donde se van a lanzar los contenedores)