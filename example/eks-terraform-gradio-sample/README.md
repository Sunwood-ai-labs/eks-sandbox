# EKS with Terraform Sample Project

このプロジェクトは、TerraformでAmazon EKS (Elastic Kubernetes Service) クラスターを作成するサンプルです。

## 前提条件

- [Terraform](https://www.terraform.io/downloads.html) (v1.0.0以上)
- [AWS CLI](https://aws.amazon.com/cli/) (設定済み)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

## プロジェクト構成

```
.
├── main.tf          # メインのTerraform設定
├── variables.tf     # 変数定義
├── outputs.tf       # 出力定義
├── providers.tf     # プロバイダー設定
├── eks.tf          # EKSクラスター設定
├── vpc.tf          # VPC設定
└── README.md       # このファイル
```

## 使用方法

1. 初期化

```bash
terraform init
```

2. 計画の確認

```bash
terraform plan
```

3. リソースの作成

```bash
terraform apply
```

4. クラスターへの接続設定

```bash
aws eks update-kubeconfig --name eks-sample-cluster --region ap-northeast-1
```

5. クラスターの状態確認

```bash
kubectl get nodes
```

## リソースの削除

```bash
terraform destroy
```

## 注意事項

このサンプルプロジェクトは学習目的で作成されています。実際の本番環境では、セキュリティやスケーラビリティを考慮した追加設定が必要です。
