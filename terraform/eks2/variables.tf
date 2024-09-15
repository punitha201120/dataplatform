variable "environment" {
 type = string
 default = "d1" 
}

# variable "profile" {
#   type = string
# }
variable "aws_region"{
  type = string
  default = "us-east-2"
}

variable resource_names {
  type        = any
}

variable tags {
  type = any
}
variable "sequence" {
 type = string
 default = "000" 
}
variable "vpc_id" {
  type =any
}
variable "subnet_ids" {
  type =list(string)
}

variable "cidr_blocks" {
  type = list(string)
}
# data "aws_vpc" "selected_vpc" {
#   tags = {
#     Name = var.resource_names["development-eks"]["network"]
#   }
# }


# variable "vpc_name" {
#   description = "The name tag of the VPC"
#   type        = string
#   default     = "default_network-dev-000"  # Adjust as needed
# }

# variable "subnet_tags" {
#   description = "Map of tags to filter subnets"
#   type        = map(string)
#   default     = {
#     "control_plane" = "control-plane-subnet"
#     "worker"        = "worker-subnet"
#   }
# }

# Data source to retrieve VPC based on the name tag
# data "aws_vpc" "selected_vpc" {
#   filter {
#     name   = "tag:Name"
#     values = [var.vpc_name]
#   }
# }

# # Data source to retrieve all subnets in the selected VPC
# data "aws_subnets" "all_subnets" {
#   filter {
#     name   = "vpc-id"
#     values = [data.aws_vpc.selected_vpc.id]
#   }
# }


