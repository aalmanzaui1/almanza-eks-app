resource "aws_ecr_repository" "ecr-repository" {
  provider        = aws.region-master
  name                 = var.deploy-name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}