# provider "kubernetes" {
#   config_path    = "~/.kube/config"
# #   config_context = "my-context"
# }

# # resource "kubernetes_namespace" "example" {
# #   metadata {
# #     name = "my-test-namespace"
# #   }
# # }


provider "kubectl" {
  config_path    = "~/.kube/config"
  # host                   = var.eks_cluster_endpoint
  # cluster_ca_certificate = base64decode(var.eks_cluster_ca)
  # token                  = data.aws_eks_cluster_auth.main.token
  # load_config_file       = false
}

data "kubectl_file_documents" "namespace" {
    content = file("namespace.yaml")
} 

data "kubectl_file_documents" "argocd" {
    content = file("install.yaml")
}

resource "kubectl_manifest" "namespace" {
    count     = length(data.kubectl_file_documents.namespace.documents)
    yaml_body = element(data.kubectl_file_documents.namespace.documents, count.index)
    override_namespace = "argocd"
}

resource "kubectl_manifest" "argocd" {
    depends_on = [
      kubectl_manifest.namespace,
    ]
    count     = length(data.kubectl_file_documents.argocd.documents)
    yaml_body = element(data.kubectl_file_documents.argocd.documents, count.index)
    override_namespace = "argocd"
}