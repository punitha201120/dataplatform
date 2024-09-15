resource "aws_s3_bucket" "tfstate" {
  for_each = var.resource_names["terraform-backend"]
  bucket = format("%s-%s-%s-%s",var.prefix,local.resource_type_naming.aws_s3_bucket,each.value["name"],var.environment)
  tags = var.tags
}
