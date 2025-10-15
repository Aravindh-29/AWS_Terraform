resource "aws_ecr_repository" "ecr" {
  name = var.ecr.name
  image_tag_mutability = var.ecr.image_tag_mutability
  image_scanning_configuration {
    scan_on_push = true
  }
}