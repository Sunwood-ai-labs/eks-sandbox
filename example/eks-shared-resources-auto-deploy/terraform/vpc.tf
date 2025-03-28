module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.availability_zones
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  # NAT Gatewayを有効化してプライベートサブネットからのインターネットアクセスを可能にする
  enable_nat_gateway = true
  single_nat_gateway = true

  # DNSサポートを有効化
  enable_dns_hostnames = true
  enable_dns_support   = true

  # EKS用のタグを追加
  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }

  tags = var.default_tags
}
