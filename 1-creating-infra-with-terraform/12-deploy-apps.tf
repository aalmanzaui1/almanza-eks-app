/*resource "null_resource" "deploy-traefik-helm" {
  provisioner "local-exec" {
    command = "helm install traefik ../03-traefik/traefik/"
  }
  depends_on = [aws_eks_cluster.eks-cluster,aws_ecr_repository.ecr-repository,aws_eks_node_group.eks-cluster-nodes]
}*/

resource "null_resource" "deploy-app-folder" {
  provisioner "local-exec" {
    command = "kubectl apply -f ../tmp/k8s/${timestamp()}/"
  }
  depends_on = [aws_eks_cluster.eks-cluster,aws_ecr_repository.ecr-repository,aws_eks_node_group.eks-cluster-nodes]
}