

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.20.0"

  cluster_name    = format("%s-%s-%s",var.resource_names["default-eks"].name,var.environment,var.sequence)
  cluster_version = "1.28"
  
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
      before_compute           = true
      service_account_role_arn = module.vpc_cni_irsa.iam_role_arn
      configuration_values = jsonencode({
        env = {
          # Reference docs https://docs.aws.amazon.com/eks/latest/userguide/cni-increase-ip-addresses.html
          ENABLE_PREFIX_DELEGATION = "true"
          WARM_PREFIX_TARGET       = "1"
        }
      })
    }
  }

  vpc_id                         = var.vpc_id
  subnet_ids                     = var.subnet_ids
  control_plane_subnet_ids       = var.subnet_ids
  cluster_endpoint_public_access = true

  eks_managed_node_groups = var.resource_names["default-eks"]["node_groups"]
}


# https://aws.amazon.com/blogs/containers/amazon-ebs-csi-driver-is-now-generally-available-in-amazon-eks-add-ons/ 
data "aws_iam_policy" "ebs_csi_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

module "irsa-ebs-csi-eks-default" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "4.7.0"
  create_role                   = true
  role_name                     = "AmazonEKSTFEBSCSIRole-${module.eks.cluster_name}"
  provider_url                  = module.eks.oidc_provider
  role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
}

# resource "aws_eks_addon" "ebs-csi-default" {
#   cluster_name             = module.eks.cluster_name
#   addon_name               = "aws-ebs-csi-driver"
#   addon_version            = "v1.20.0-eksbuild.1"
#   service_account_role_arn = module.irsa-ebs-csi-eks-default.iam_role_arn
#   tags = {
#     "eks_addon" = "ebs-csi"
#     "terraform" = "true"
#   }
# }

resource "aws_security_group" "allow_nfs_eks_default" {
  name        = format("%s-%s","allow nfs for efs",var.resource_names["default-eks"]["name"])
  description = "Allow NFS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "All Traffic from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.cidr_blocks
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}

##THese are dependent on which EKS we want the aws_efs_file_sysatem
resource "aws_efs_file_system" "stw_node_efs_eks_default" {
  creation_token = format("%s-%s","efs-for-stw-node",var.resource_names["default-eks"]["name"])

  lifecycle {
    # prevent_destroy = true
  }
}

resource "aws_efs_mount_target" "stw_node_efs_mt_0" {
  file_system_id  = aws_efs_file_system.stw_node_efs_eks_default.id
  subnet_id       = var.subnet_ids[0]
  security_groups = [aws_security_group.allow_nfs_eks_default.id]
}

resource "aws_efs_mount_target" "stw_node_efs_mt_1" {
  file_system_id  = aws_efs_file_system.stw_node_efs_eks_default.id
  subnet_id       =var.subnet_ids[1]
  security_groups = [aws_security_group.allow_nfs_eks_default.id]
}

provider "helm" {
  #for_each   = var.resource_names["eks"]
  alias = "default_cluster"
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
      command     = "aws"
    }
  }
}

# resource "helm_release" "aws_efs_csi_driver" {
#   provider   = helm.default_cluster
#   chart      = "aws-efs-csi-driver"
#   name       = "aws-efs-csi-driver"
#   namespace  = "kube-system"
#   repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver/"

#   set {
#     name  = "image.repository"
#     value = "602401143452.dkr.ecr.eu-west-3.amazonaws.com/eks/aws-efs-csi-driver"
#   }

#   set {
#     name  = "controller.serviceAccount.create"
#     value = true
#   }

#   set {
#     name  = "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
#     value = module.attach_efs_csi_role.iam_role_arn
#   }

#   set {
#     name  = "controller.serviceAccount.name"
#     value = "efs-csi-controller-sa"
#   }
# }

