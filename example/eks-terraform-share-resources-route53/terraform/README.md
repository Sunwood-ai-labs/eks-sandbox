# AWS EKS Infrastructure with Terraform 🚀

このディレクトリには、AWS EKSクラスターとその関連リソースのTerraform設定が含まれています。

## 🏗️ インフラストラクチャ構成

### コアコンポーネント
- EKSクラスター (eks.tf)
- VPCと関連ネットワーク (vpc.tf)
- Route53 DNS設定 (route53.tf)
- ACM証明書 (acm.tf)
- ECRリポジトリ (main.tf)

### ネットワーク構成
- VPC CIDR: 10.0.0.0/16
- アベイラビリティゾーン: 3つ
- プライベートサブネット: 3つ
- パブリックサブネット: 3つ
- NAT Gateway: Single AZ

### セキュリティ設定
- SSL/TLS証明書（ACM）
- セキュリティグループ
- IAMロールと権限

## 🚀 デプロイ手順

1. 環境変数の設定
```bash
cp ../.env.example ../.env
# .envファイルを編集
```

2. Terraformの初期化
```bash
terraform init
```

3. 設定の確認
```bash
terraform plan
```

4. インフラのデプロイ
```bash
terraform apply
```

5. kubeconfig の設定
```bash
aws eks update-kubeconfig --name $(terraform output -raw cluster_id) --region $(terraform output -raw region)
```

## 📦 モジュール構成

### VPC モジュール
- CIDR: 10.0.0.0/16
- プライベートサブネット: 10.0.1.0/24, 10.0.2.0/24, 10.0.3.0/24
- パブリックサブネット: 10.0.101.0/24, 10.0.102.0/24, 10.0.103.0/24

### EKS モジュール
- Kubernetesバージョン: 1.32
- ノードグループ設定:
  - インスタンスタイプ: t3.medium
  - 最小ノード数: 1
  - 最大ノード数: 3
  - 希望ノード数: 1

## 🔧 変数設定

主な変数は `terraform.tfvars` で設定可能です：
- リージョン
- クラスター名
- VPC設定
- ノードグループ設定
- Route53/ACM設定

## 🧹 クリーンアップ

リソースの削除：
```bash
terraform destroy
```

## ⚠️ 注意事項

- プロダクション環境での使用前に、セキュリティ設定を見直してください
- コスト管理のため、使用しないリソースは適切に削除してください
- バックアップとディザスタリカバリの計画を立ててください
