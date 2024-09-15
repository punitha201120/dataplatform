#profile = "production"
aws_region = "us-east-2"
# azs    = [{name = "a", value = "us-east-2a"},{name = "b", value = "us-east-2b"}]

tags = {
    Live                   = "no"
    Project                = "POC"
    OwnedBy                = "Accolite"
}

environment = "dev"
prefix = "acco"


# resource_names = {
#   "terraform-store" = {
#     terraform_bucket = {name = "terraform-store"},
#   },
# }
resource_names = {
  "storage" = {
    s3_landing = {name = "etl"},
  }
}
