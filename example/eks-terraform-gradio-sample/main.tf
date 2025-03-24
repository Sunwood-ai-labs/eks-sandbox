# EKS with Terraform Sample Project

# このファイルはプロジェクトのメインエントリーポイントです
# VPCとEKSクラスターの作成はそれぞれのモジュールファイルで定義されています

# 必要なローカル変数
locals {
  cluster_name = var.cluster_name
}

# クラスター作成後に実行するコマンド例（Terraform apply後に手動で実行）
resource "null_resource" "example" {
  depends_on = [module.eks]

  provisioner "local-exec" {
    command = <<-EOT
      echo "EKSクラスター '${module.eks.cluster_id}' が作成されました。"
      echo "kubectlの設定を更新するには次のコマンドを実行してください："
      echo "aws eks update-kubeconfig --name ${module.eks.cluster_id} --region ${var.region}"
    EOT
  }
}
