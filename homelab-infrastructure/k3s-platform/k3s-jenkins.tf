resource "kubernetes_namespace" "jenkins_space" {
  metadata {
    name = "jenkins"
  }
}

resource "helm_release" "jenkins" {
  name       = "jenkins"
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  namespace  = kubernetes_namespace.jenkins_space.metadata[0].name

  values = [
    <<-EOT
    controller:
      resources:
        requests:
          cpu: "300m"
          memory: "512Mi"
        limits:
          cpu: "1000m"
          memory: "1536Mi"
      serviceType: "NodePort"
      nodePort: 32000
    EOT
  ]
}
