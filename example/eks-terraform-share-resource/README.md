# EKS Shared Resources Sample 🚀

複数のGradioアプリケーションをAWS EKSクラスターで効率的に実行するサンプルプロジェクト

## 📑 目次
- [📑 目次](#-目次)
- [📱 概要](#-概要)
- [🛠️ 技術スタック](#️-技術スタック)
- [📋 前提条件](#-前提条件)
- [🚀 デプロイ手順](#-デプロイ手順)
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

1. 環境変数の設定
```bash
cp .env.example .env
# .envファイルを編集して必要な値を設定
```

2. インフラストラクチャのデプロイ
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

3. kubectlの設定
```bash
aws eks update-kubeconfig --name $(terraform output -raw cluster_id) --region $(terraform output -raw region)
```

4. アプリケーションのビルドとデプロイ
```bash
# ECRログイン
eval $(terraform output docker_login_command)

# アプリケーションのビルドとプッシュ
cd ../apps
for app in counter calculator text; do
  docker build --build-arg APP_DIR=app${app%counter?1:calculator?2:3} -t gradio-apps:$app .
  docker tag gradio-apps:$app $(terraform output -raw ecr_repository_url):$app
  docker push $(terraform output -raw ecr_repository_url):$app
done

# Kubernetesへのデプロイ
kubectl apply -f k8s-deployments.yaml
```

5. アプリケーションのアクセス
```bash
kubectl get service
# 各サービスのELBエンドポイントにアクセス
```

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

```bash
# アプリケーションの削除
kubectl delete -f apps/k8s-deployments.yaml

# インフラの削除
cd terraform
terraform destroy
```

## ⚠️ 注意事項

- このプロジェクトはデモ用のサンプルです
- 本番環境では適切なセキュリティ設定を行ってください
- 使用後は必ずリソースを削除してください
