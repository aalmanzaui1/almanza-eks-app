output "endpoint" {
  value = aws_eks_cluster.eks-cluster.endpoint
}

# output "kubeconfig-certificate-authority-data" {
#   value = aws_eks_cluster.example.certificate_authority[0].data
# }

output "ecr-repository" {
  value = aws_ecr_repository.ecr-repository.repository_url
}