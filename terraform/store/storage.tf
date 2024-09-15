resource "aws_s3_bucket" "storages" {
  for_each = var.resource_names["storage"]
  bucket = format("%s-%s-%s",each.value["name"],var.environment,var.sequence)
  tags = var.tags
}

resource "aws_s3_object" "s3_incoming_folder" {
    provider = aws
    bucket   = aws_s3_bucket.storages["s3_landing"].id
    acl      = "private"
    key      =  "incoming/"
    content_type = "application/x-directory"
}

resource "aws_s3_object" "s3_outgoing_folder" {
    provider = aws
    bucket   = aws_s3_bucket.storages["s3_landing"].id
    acl      = "private"
    key      =  "outgoing/"
    content_type = "application/x-directory"
}

resource "aws_s3_object" "s3_processed_folder" {
    provider = aws
    bucket   = aws_s3_bucket.storages["s3_landing"].id
    acl      = "private"
    key      =  "processed/"
    content_type = "application/x-directory"
}
