variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "eks-shared-cluster"
}

variable "vpc_name" {
  description = "VPC name"
  type        = string
  default     = "eks-shared-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones to use"
  type        = list(string)
  default     = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
}

variable "private_subnets" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "node_group_name" {
  description = "Node group name"
  type        = string
  default     = "eks-shared-node-group"
}

variable "node_instance_type" {
  description = "Instance type for nodes"
  type        = string
  default     = "t3.medium"
}

variable "node_desired_capacity" {
  description = "Desired number of nodes"
  type        = number
  default     = 1
}

variable "node_max_capacity" {
  description = "Maximum number of nodes"
  type        = number
  default     = 3
}

variable "node_min_capacity" {
  description = "Minimum number of nodes"
  type        = number
  default     = 1
}

variable "default_tags" {
  description = "Default tags to apply to resources"
  type        = map(string)
  default     = {
    Environment = "dev"
    Project     = "eks-shared"
    ManagedBy   = "terraform"
  }
}

variable "domain" {
  description = "パブリックドメイン"
  type        = string
  default     = "sunwood-ai-labs.com"
}

variable "route53_zone_id" {
  description = "パブリックゾーンID"
  type        = string
  default     = "Z06109853GUFEWBX9FFP2"
}
