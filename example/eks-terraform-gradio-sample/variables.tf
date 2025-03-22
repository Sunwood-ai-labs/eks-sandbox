variable "region" {
  description = "AWSu30eau30fcu30b8u30e7u30f3"
  type        = string
  default     = "ap-northeast-1"
}

variable "cluster_name" {
  description = "EKSu30afu30e9u30b9u30bfu30fcu540d"
  type        = string
  default     = "eks-sample-cluster"
}

variable "vpc_name" {
  description = "VPCu540d"
  type        = string
  default     = "eks-vpc"
}

variable "vpc_cidr" {
  description = "VPCu306eCIDRu30d6u30edu30c3u30af"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "u5229u7528u3059u308bu30a2u30d9u30a4u30e9u30d3u30eau30c6u30a3u30beu30fcu30f3"
  type        = list(string)
  default     = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
}

variable "private_subnets" {
  description = "u30d7u30e9u30a4u30d9u30fcu30c8u30b5u30d6u30cdu30c3u30c8u306eCIDRu30d6u30edu30c3u30af"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
  description = "u30d1u30d6u30eau30c3u30afu30b5u30d6u30cdu30c3u30c8u306eCIDRu30d6u30edu30c3u30af"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "node_group_name" {
  description = "u30ceu30fcu30c9u30b0u30ebu30fcu30d7u540d"
  type        = string
  default     = "eks-node-group"
}

variable "node_instance_type" {
  description = "u30ceu30fcu30c9u306eu30a4u30f3u30b9u30bfu30f3u30b9u30bfu30a4u30d7"
  type        = string
  default     = "t3.medium"
}

variable "node_desired_capacity" {
  description = "u30ceu30fcu30c9u306eu5e0cu671bu6570"
  type        = number
  default     = 2
}

variable "node_max_capacity" {
  description = "u30ceu30fcu30c9u306eu6700u5927u6570"
  type        = number
  default     = 3
}

variable "node_min_capacity" {
  description = "u30ceu30fcu30c9u306eu6700u5c0fu6570"
  type        = number
  default     = 1
}

variable "default_tags" {
  description = "u30c7u30d5u30a9u30ebu30c8u3067u4ed8u4e0eu3059u308bu30bfu30b0"
  type        = map(string)
  default     = {
    Environment = "dev"
    Project     = "eks-sample"
    ManagedBy   = "terraform"
  }
}
