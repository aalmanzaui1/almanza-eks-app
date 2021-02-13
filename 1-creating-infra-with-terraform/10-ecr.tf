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
    depends_on = [aws_eks_cluster.eks-cluster]
}

resource "null_resource" "build-docker-cn1" {
  provisioner "local-exec" {
    command = "docker build -t ${aws_ecr_repository.ecr-repository.repository_url}:cn1v1 ../2-docker-images-app/cn1/ && docker push ${aws_ecr_repository.ecr-repository.repository_url}:cn1v1"
  }
  depends_on = [aws_eks_cluster.eks-cluster,aws_ecr_repository.ecr-repository]
}

resource "null_resource" "build-docker-cn2" {
  provisioner "local-exec" {
    command = "docker build -t ${aws_ecr_repository.ecr-repository.repository_url}:cn2v1 ../2-docker-images-app/cn2/ && docker push ${aws_ecr_repository.ecr-repository.repository_url}:cn2v1"
  }
  depends_on = [aws_eks_cluster.eks-cluster,aws_ecr_repository.ecr-repository]
}

locals {
  container1_deploy = <<-EOT
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    creationTimestamp: null
    labels:
      app: almanza-cn1
    name: almanza-cn1
  spec:
    replicas: 1
    selector:
      matchLabels:
        app: almanza-cn1
    strategy: {}
    template:
      metadata:
        creationTimestamp: null
        labels:
          app: almanza-cn1
      spec:
        containers:
        - image: ${aws_ecr_repository.ecr-repository.repository_url}:cn1v1
          name: almanza-app-cn1
          resources: {}
          ports:
          - containerPort: 8080
  status: {}

 EOT
}

locals {
  container2_deploy = <<-EOT
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    creationTimestamp: null
    labels:
      app: almanza-cn2
    name: almanza-cn2
  spec:
    replicas: 1
    selector:
      matchLabels:
        app: almanza-cn2
    strategy: {}
    template:
      metadata:
        creationTimestamp: null
        labels:
          app: almanza-cn2
      spec:
        containers:
        - image: ${aws_ecr_repository.ecr-repository.repository_url}:cn2v1
          name: almanza-app-cn2
          resources: {}
          ports:
          - containerPort: 8080
  status: {}

 EOT
}

locals {
  services = <<-EOT
  apiVersion: v1
  kind: Service
  metadata:
    name: almanza-service-cn1
  spec:
    selector:
      app: almanza-cn1
    ports:
      - protocol: TCP
        port: 80
        targetPort: 8080
  ---
  apiVersion: v1
  kind: Service
  metadata:
    name: almanza-service-cn2
  spec:
    selector:
      app: almanza-cn2
    ports:
      - protocol: TCP
        port: 80
        targetPort: 8080

 EOT
}

resource "local_file" "container1_deployment" {
  filename = "../3-app/container1_deployment.yml"
  content  = local.container1_deploy
  depends_on = [aws_eks_cluster.eks-cluster,aws_ecr_repository.ecr-repository]
}

resource "local_file" "container2_deployment" {
  filename = "../3-app/container2_deployment.yml"
  content  = local.container2_deploy
  depends_on = [aws_eks_cluster.eks-cluster,aws_ecr_repository.ecr-repository]
}

resource "local_file" "services-k8s" {
  filename = "../3-app/services.yml"
  content  = local.services
  depends_on = [aws_eks_cluster.eks-cluster,aws_ecr_repository.ecr-repository]
}