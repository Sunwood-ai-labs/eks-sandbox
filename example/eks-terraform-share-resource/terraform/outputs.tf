output "cluster_id" {
  description = "EKSクラスターID"
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "EKSクラスターエンドポイント"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "クラスターセキュリティグループID"
  value       = module.eks.cluster_security_group_id
}

output "region" {
  description = "リージョン"
  value       = var.region
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "configure_kubectl" {
  description = "kubectlの設定コマンド"
  value       = "aws eks update-kubeconfig --name ${module.eks.cluster_id} --region ${var.region}"
}

output "ecr_repository_url" {
  description = "ECRリポジトリのURL"
  value       = aws_ecr_repository.gradio_apps.repository_url
}

output "ecr_repository_name" {
  description = "ECRリポジトリ名"
  value       = aws_ecr_repository.gradio_apps.name
}

output "docker_login_command" {
  description = "ECRログインコマンド"
  value       = "aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${aws_ecr_repository.gradio_apps.repository_url}"
}
