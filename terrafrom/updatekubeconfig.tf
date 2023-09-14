resource "null_resource" "update_kubeconfig" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region=${var.aws_region} --name=${aws_eks_cluster.eks_cluster.id}"
    # arguments = [
    #   "eks",
    #   "update-kubeconfig",
    #   "--region", "${var.aws_region}",
    #   "--name", "${output.cluster_id}",
    # ]
  }
}