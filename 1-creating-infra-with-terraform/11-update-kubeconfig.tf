resource "null_resource" "build-docker-cn2" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${aws_eks_cluster-eks-cluster.name}"
  }
}

