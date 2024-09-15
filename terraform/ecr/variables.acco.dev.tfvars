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
  "ecr" = {
    app_repo = {name = "app"},
    postgres_repo = {name = "postgres"},
    pyspark-notebook = {name = "pyspark-notebook"},
    spark = {name = "spark"},
  }
}