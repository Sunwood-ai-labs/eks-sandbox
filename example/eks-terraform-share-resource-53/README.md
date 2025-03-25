# EKS Shared Resources Sample 🚀

![Image](https://github.com/user-attachments/assets/fd170d5c-8df4-4261-8e45-bd8e7a9a1511)

複数のGradioアプリケーションをAWS EKSクラスターで効率的に実行するサンプルプロジェクト

## 📑 目次
- [📑 目次](#-目次)
- [📱 概要](#-概要)
- [🛠️ 技術スタック](#️-技術スタック)
- [📋 前提条件](#-前提条件)
- [🚀 デプロイ手順](#-デプロイ手順)
  - [Linux/macOSでのデプロイ](#linuxmacosでのデプロイ)
  - [Windowsでのデプロイ](#windowsでのデプロイ)
- [⚙️ リソースの最適化](#️-リソースの最適化)
  - [現在の設定](#現在の設定)
  - [推奨ノード設定](#推奨ノード設定)
  - [スケーリングの考え方](#スケーリングの考え方)
- [🧹 クリーンアップ](#-クリーンアップ)
- [⚠️ 注意事項](#️-注意事項)

## 📱 概要

このプロジェクトは、以下の3つのGradioアプリケーションをEKS上で実行します：

- **カウンターアプリ**: シンプルなカウントアップとリセット機能
- **計算機アプリ**: 基本的な四則演算機能
- **テキスト変換アプリ**: テキストの大文字/小文字変換、反転機能

## 🛠️ 技術スタック

- AWS EKS (Kubernetes管理サービス)
- Terraform (インフラストラクチャのコード化)
- Docker (コンテナ化)
- Gradio (Pythonウェブアプリケーション)

## 📋 前提条件

- AWS CLI (設定済み)
- Terraform v1.0.0以上
- Docker
- kubectl

## 🚀 デプロイ手順

### Linux/macOSでのデプロイ

1. リポジトリのクローンとディレクトリ移動
```bash
git clone <repository-url>
cd eks-terraform-share-resource-53
```

2. 環境変数の設定
```bash
cp .env.example .env
# .envファイルを編集して必要な値を設定
```

3. Terraformによるインフラストラクチャのデプロイ
```bash
cd terraform
terraform init
terraform plan   # プランの確認
terraform apply  # インフラのデプロイ
```

4. EKSクラスターへのkubectlの設定
```bash
aws eks update-kubeconfig --name $(terraform output -raw cluster_id) --region $(terraform output -raw region)
```

5. ECRリポジトリへのログインとデプロイスクリプトの実行
```bash
cd ../apps
chmod +x deploy.sh
./deploy.sh
```

6. アプリケーションの状態確認
```bash
kubectl get pods     # Podの状態確認
kubectl get service  # LoadBalancerのエンドポイント確認
```

### Windowsでのデプロイ

1. リポジトリのクローンとディレクトリ移動
```powershell
git clone <repository-url>
cd eks-terraform-share-resource-53
```

2. 環境変数の設定
```powershell
Copy-Item .env.example .env
# .envファイルを編集して必要な値を設定
```

3. Terraformによるインフラストラクチャのデプロイ
```powershell
cd terraform
terraform init
terraform plan   # プランの確認
terraform apply  # インフラのデプロイ

# 環境変数の設定
$env:ECR_REPOSITORY_URL = terraform output -raw ecr_repository_url
```

4. EKSクラスターへのkubectlの設定
```powershell
aws eks update-kubeconfig --name $(terraform output -raw cluster_id) --region $(terraform output -raw region)
```

5. PowerShellデプロイスクリプトの実行
```powershell
cd ../apps
./deploy.ps1
```

6. アプリケーションの状態確認
```powershell
kubectl get pods     # Podの状態確認
kubectl get service  # LoadBalancerのエンドポイント確認
```

アプリケーションへのアクセス：
- 各サービスの`EXTERNAL-IP`カラムに表示されるURLにアクセス
- ポート80でアクセス可能
  - カウンターアプリ: http://<counter-service-url>
  - 計算機アプリ: http://<calculator-service-url>
  - テキスト変換アプリ: http://<text-service-url>

## ⚙️ リソースの最適化

### 現在の設定

- 各アプリケーションのリソース要求:
  - CPU: 100m
  - メモリ: 256Mi

### 推奨ノード設定

```hcl
# terraform/variables.tf
node_desired_capacity = 1  # 通常運用
node_max_capacity     = 3  # 負荷対応
node_min_capacity     = 1  # 最小構成
```

### スケーリングの考え方

- 通常時は1ノードで十分な処理が可能
- 負荷増大時は自動でスケールアウト（最大3ノード）
- コスト最適化のため、不要なノードは自動削除

## 🧹 クリーンアップ

リソースの削除は以下の順序で行います：

1. アプリケーションの削除
```bash
kubectl delete -f apps/k8s-deployments.yaml
```

2. インフラの削除
```bash
cd terraform
terraform destroy
```

3. ローカルのkubectlコンテキストのクリーンアップ
```bash
kubectl config delete-context <cluster-context-name>
```

## ⚠️ 注意事項

- このプロジェクトはデモ用のサンプルです
- 本番環境では以下の点を考慮してください：
  - 適切なセキュリティグループの設定
  - SSL/TLS証明書の導入
  - バックアップ戦略の実装
  - モニタリングとアラートの設定
- 使用後は必ずリソースを削除してください
- 長時間の運用は避け、必要な時だけデプロイすることをお勧めします
