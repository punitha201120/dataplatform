resource "aws_ecr_repository" "app_ecr_repo" {
  for_each = var.resource_names["ecr"]
  name = format("%s-%s-%s",each.value["name"],var.environment,var.sequence)
}