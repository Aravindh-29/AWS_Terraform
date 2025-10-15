
variable "ecr" {
  type = object({
    name = string
    image_tag_mutability = string
  })
}
