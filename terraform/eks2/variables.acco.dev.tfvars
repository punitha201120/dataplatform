#profile = "production"
aws_region = "us-east-2"
# azs    = [{name = "a", value = "us-east-2a"},{name = "b", value = "us-east-2b"}]

tags = {
    Live                   = "no"
    Project                = "POC"
    OwnedBy                = "Accolite"
}

environment = "dev"
sequence = "000"
prefix = "acco"


resource_names = {
 # "vpc" = {
  #   default_network = {
  #                      name = "default_network",
  #                      cidr="10.0.0.0/16", 
  #                      # Eight subnets from 10.0.0.0 to 10.0.31.255. Each subnet will have 512 IPs
  #                      # This way we can have 128 subnets
  #                      # Public subnets will be picked from the end
  #                      private_subnets=[7,7,7,7,7,7,7,7],
  #                      public_subnets=[7,7,7],
  #                      enable_nat_gateway=true, 
  #                      single_nat_gateway=true,
  #                      enable_dns_hostnames=true
  #                     },
  # },
  "default-eks" = {
    name ="default"
    network = "default_network",
    subnets = [0,1,2,3],
    node_groups = {
      one = {
        name = "node-group-1"
        instance_types = ["t3.2xlarge"]
        min_size     = 1
        max_size     = 8
        desired_size = 3
      }
      two = {
        name = "node-group-2"
        instance_types = ["t3.2xlarge"]
        min_size     = 1
        max_size     = 8
        desired_size = 3
      }
    }
  },
  "developer-eks" = {
    name ="developer"
    network = "default_network",
    subnets = [4,5,6,7],
    node_groups = {
      default = {
        min_size     = 1
        max_size     = 8
        desired_size = 2

        instance_types = ["t3.xlarge"]
        capacity_type  = "ON_DEMAND"

        # Needed by the aws-ebs-csi-driver
        iam_role_additional_policies = {
          AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
        }
      }
      additional = {
        min_size     = 1
        max_size     = 8
        desired_size = 2

        instance_types = ["t3.xlarge"]
        capacity_type  = "ON_DEMAND"

        # Needed by the aws-ebs-csi-driver
        iam_role_additional_policies = {
          AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
        }
      }
    }
  },
  # "appconfig" = {
  #   etlConfig = {
  #                     name = "etlConfig",
  #                     profiles = ["config_profile","schema_profile"],
  #                     environment="etlEnv",
  #                     deployment="etlDeployment"
  #                     },
  # },
}
