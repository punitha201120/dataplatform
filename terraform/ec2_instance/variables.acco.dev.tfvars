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


resource_names = {
  "ec2_instance" = {
    instance = {name = "terraform-ec2"},
  },
}