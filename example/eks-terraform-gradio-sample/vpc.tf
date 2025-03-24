# VPCu30e2u30b8u30e5u30fcu30ebu3092u4f7fu7528u3057u3066EKSu7528u306eVPCu3092u4f5cu6210
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.availability_zones
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  # NAT Gatewayu3092u6709u52b9u5316u3057u3066u30d7u30e9u30a4u30d9u30fcu30c8u30b5u30d6u30cdu30c3u30c8u304bu3089u306eu30a4u30f3u30bfu30fcu30cdu30c3u30c8u30a2u30afu30bbu30b9u3092u53efu80fdu306bu3059u308b
  enable_nat_gateway = true
  single_nat_gateway = true

  # DNSu30b5u30ddu30fcu30c8u3092u6709u52b9u5316
  enable_dns_hostnames = true
  enable_dns_support   = true

  # EKSu7528u306eu30bfu30b0u3092u8ffdu52a0
  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }
}
