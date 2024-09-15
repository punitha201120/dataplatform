locals{
    resource_type_naming = {
        aws_vpc = "vpc",
        aws_subnet = "sub",
		aws_eks = "eks",
        aws_appConfig= "apco",
        aws_appconfig_environment = "acenv",
		aws_appconfig_deployment_strategy = "acds",
        aws_appconfig_configuration_profile = "aacp",
		aws_appconfig_hosted_configuration_version = "ahcv",
		aws_appconfig_deployment = "adep",
		aws_eks_addon = "ekad",
		aws_security_group = "sg",
		aws_efs_file_system = "efs",
		aws_efs_mount_target = "efmt",
		aws_s3_bucket = "s3",
		aws_s3_object = "s3o",
		aws_ecr_repository = "ecr",
		aws_appconfig_application = "acap"
    }

}
# locals {
#   vpc_id = data.aws_vpc.selected_vpc.id

#   subnet_ids = [
#     for subnet_id in data.aws_subnets.all_subnets.ids :
#     subnet_id if contains(data.aws_subnets.all_subnets.tags[subnet_id])
#   ]

#   control_plane_subnet_ids = [
#     for subnet_id in data.aws_subnets.all_subnets.ids :
#     subnet_id if contains(data.aws_subnets.all_subnets.tags[subnet_id])
#   ]
#   vpc_cidr_block = data.aws_vpc.selected_vpc.cidr_block
# }
# locals {
#   vpc_id = data.aws_vpc.selected_vpc.id

#   # Filter subnets for private and control plane based on tags
#   subnet_ids = [
#     for subnet in data.aws_subnets.all_subnets.ids :
#     subnet if contains(data.aws_subnets.all_subnets.tags[subnet], var.subnet_tags["private"])
#   ]

#   control_plane_subnet_ids = [
#     for subnet in data.aws_subnets.all_subnets.ids :
#     subnet if contains(data.aws_subnets.all_subnets.tags[subnet], var.subnet_tags["control_plane"])
#   ]

#   # Retrieve the VPC CIDR block
#   vpc_cidr_block = data.aws_vpc.selected_vpc.cidr_block
# }
