locals {
    azs = slice(data.aws_availability_zones.available.names, 0, 2)
}

module "default_virtual_network" {
  for_each = var.resource_names["vpc"]
  source  = "terraform-aws-modules/vpc/aws"
  
  version = "~> 5.1"

  name    = format("%s-%s-%s",each.value["name"],var.environment,var.sequence)
  cidr    = each.value["cidr"]
  instance_tenancy = "default"
  azs             = local.azs
  private_subnets = [for k, v in each.value["private_subnets"]: cidrsubnet(each.value["cidr"], v, k)]
  public_subnets  = [for k, v in each.value["public_subnets"]: cidrsubnet(each.value["cidr"], v, 127-k)] ## We will public subnets from the end

  enable_nat_gateway   =  each.value["enable_nat_gateway"]
  single_nat_gateway   =  each.value["single_nat_gateway"]
  enable_dns_hostnames =  each.value["enable_dns_hostnames"]

}

