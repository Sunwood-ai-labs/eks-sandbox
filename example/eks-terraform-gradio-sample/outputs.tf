output "cluster_id" {
  description = "EKSu30afu30e9u30b9u30bfu30fcID"
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "EKSu30afu30e9u30b9u30bfu30fcu30a8u30f3u30c9u30ddu30a4u30f3u30c8"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "u30afu30e9u30b9u30bfu30fcu30bbu30adu30e5u30eau30c6u30a3u30b0u30ebu30fcu30d7ID"
  value       = module.eks.cluster_security_group_id
}

output "region" {
  description = "u30eau30fcu30b8u30e7u30f3"
  value       = var.region
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "configure_kubectl" {
  description = "kubectlu306eu8a2du5b9au30b3u30deu30f3u30c9"
  value       = "aws eks update-kubeconfig --name ${module.eks.cluster_id} --region ${var.region}"
}
