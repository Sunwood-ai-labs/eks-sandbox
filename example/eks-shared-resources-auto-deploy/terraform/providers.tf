terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.10.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "aws" {
  region = var.region
  
  # タグをデフォルトで付与
  default_tags {
    tags = var.default_tags
  }
}

# EKSクラスターの認証情報を取得するためのデータソース
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
  depends_on = [module.eks.cluster_id]
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
  depends_on = [module.eks.cluster_id]
}

# Kubernetesプロバイダーの設定
provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}
