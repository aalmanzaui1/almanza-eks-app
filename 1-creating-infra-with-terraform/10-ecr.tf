resource "aws_ecr_repository" "ecr-repository" {
  provider             = aws.region-master
  name                 = var.deploy-name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }

  provisioner "local-exec" {
    command = "aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin ${aws_ecr_repository.ecr-repository.repository_url}"
  }

}

resource "null_resource" "build-docker-cn1" {
  provisioner "local-exec" {
    command = "docker build -t ${aws_ecr_repository.ecr-repository.repository_url}:cn1v1 ../2-docker-images-app/cn1/ && docker push ${aws_ecr_repository.ecr-repository.repository_url}:cn1v1"
  }
}

resource "null_resource" "build-docker-cn2" {
  provisioner "local-exec" {
    command = "docker build -t ${aws_ecr_repository.ecr-repository.repository_url}:cn2v1 ../2-docker-images-app/cn2/ && docker push ${aws_ecr_repository.ecr-repository.repository_url}:cn2v1"
  }
}