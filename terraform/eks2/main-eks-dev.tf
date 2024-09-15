variable "coder_version" {
  default = "2.0.1"
}

variable "db_password" {
  default = "coder"
}




module "eks_development" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.20.0"

  vpc_id                         = var.vpc_id
  subnet_ids                     = var.subnet_ids
  control_plane_subnet_ids       = var.subnet_ids
  cluster_name    = format("%s-%s-%s",var.resource_names["developer-eks"].name,var.environment,var.sequence)
  cluster_version = "1.28"

  cluster_endpoint_public_access = true
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent = true
    }
  }
  eks_managed_node_groups = var.resource_names["developer-eks"]["node_groups"]

}

provider "helm" {
  #for_each   = var.resource_names["eks"]
  alias = "development_cluster"
  kubernetes {
    host                   = module.eks_development.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks_development.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.eks_development.cluster_name]
      command     = "aws"
    }
  }
}
provider "kubernetes" {
  host                   = module.eks_development.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_development.cluster_certificate_authority_data)
  #token                  = data.aws_eks_cluster_auth.cluster_auth.token
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", module.eks_development.cluster_name]
    command     = "aws"
  }
}

resource "kubernetes_namespace" "coder_namespace" {
  metadata {
    name = "coder"
  }
}

resource "helm_release" "pg_cluster" {
  name      = "postgresql"
  provider  = helm.development_cluster
  namespace = kubernetes_namespace.coder_namespace.metadata.0.name

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql"

  set {
    name  = "auth.username"
    value = "coder"
  }

  set {
    name  = "auth.password"
    value = "${var.db_password}"
  }

  set {
    name  = "auth.database"
    value = "coder"
  }

  set {
    name  = "persistence.size"
    value = "10Gi"
  }
}

resource "helm_release" "coder" {
  name      = "coder"
  provider  = helm.development_cluster
  namespace = kubernetes_namespace.coder_namespace.metadata.0.name

  chart = "https://github.com/coder/coder/releases/download/v${var.coder_version}/coder_helm_${var.coder_version}.tgz"

  values = [
    <<EOT
coder:
  env:
    - name: CODER_PG_CONNECTION_URL
      value: "postgres://coder:${var.db_password}@${helm_release.pg_cluster.name}.coder.svc.cluster.local:5432/coder?sslmode=disable"
    - name: CODER_EXPERIMENTAL
      value: "true"
    EOT
  ]

  set {
    name  = "coder.service.sessionAffinity"
    value = "None"
  }

  depends_on = [
    helm_release.pg_cluster
  ]
}

