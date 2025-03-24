# EKS with Shared Resources Sample Project

locals {
  cluster_name = var.cluster_name
  # ECRリポジトリ名を定義
  ecr_repository_name = "gradio-apps"
}

# ECRリポジトリの作成
resource "aws_ecr_repository" "gradio_apps" {
  name = local.ecr_repository_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# クラスター作成後に実行するコマンド
resource "null_resource" "post_cluster_setup" {
  depends_on = [module.eks]

  provisioner "local-exec" {
    command = <<-EOT
      echo "EKSクラスター '${module.eks.cluster_id}' が作成されました。"
      echo "kubectlの設定を更新するには次のコマンドを実行してください："
      echo "aws eks update-kubeconfig --name ${module.eks.cluster_id} --region ${var.region}"
      echo ""
      echo "ECRリポジトリ '${aws_ecr_repository.gradio_apps.repository_url}' が作成されました。"
      echo "Dockerイメージをプッシュする前に以下のコマンドを実行してください："
      echo "aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${aws_ecr_repository.gradio_apps.repository_url}"
    EOT
  }
}
