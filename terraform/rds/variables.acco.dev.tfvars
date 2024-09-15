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
  "rds" = {
    instance = {name = "postgress-db"},
  },
}
# vpc_security_group_ids = ["sg-0123456789abcdef0", "sg-0fedcba9876543210"]
# subnet_ids             = ["subnet-0123456789abcdef0", "subnet-0fedcba9876543210"]