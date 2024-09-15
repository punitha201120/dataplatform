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
   "vpc" = {
    default_network = {
                       name = "default_network",
                       cidr="10.0.0.0/16", 
                       # Eight subnets from 10.0.0.0 to 10.0.31.255. Each subnet will have 512 IPs
                       # This way we can have 128 subnets
                       # Public subnets will be picked from the end
                       private_subnets=[7,7,7,7,7,7,7,7],
                       public_subnets=[7,7,7],
                       enable_nat_gateway=true, 
                       single_nat_gateway=true,
                       enable_dns_hostnames=true
                      },
  },
}