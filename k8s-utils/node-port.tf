resource "kubernetes_service" "example_np" {
  metadata {
    name = "terraform-example-np"
  }
  spec {
    selector = {
      app = kubernetes_deployment.example.metadata.0.labels.app # nodo al que va a enviar el trafico
    }
    port {
      port        = 80
      target_port = 80
      node_port   = 30080 # Este es el puerto en el que el servicio estará disponible en todos los nodos
    }
    type = "NodePort"
  }
}