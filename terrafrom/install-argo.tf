# provider "kubernetes" {
#   config_path    = "~/.kube/config"
# #   config_context = "my-context"
# }

# # resource "kubernetes_namespace" "example" {
# #   metadata {
# #     name = "my-test-namespace"
# #   }
# # }
data "aws_eks_cluster" "eks_cluster" {
  name     = "${local.eks_cluster_name}"
  depends_on = [ aws_eks_cluster.eks_cluster ]
}

data "aws_eks_cluster_auth" "eks_cluster_auth" {
  name     = "${local.eks_cluster_name}"
  depends_on = [ aws_eks_cluster.eks_cluster ]
}



provider "kubectl" {
  # config_path    = "~/.kube/config"
  host                   = data.aws_eks_cluster.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks_cluster_auth.token
  load_config_file       = false
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