<div align="center">

![Image](https://github.com/user-attachments/assets/3585a45e-f7cd-43a2-b9b4-1c4fb57d5ca0)

# EKS Shared Resources Sample 🚀

[![AWS](https://img.shields.io/badge/AWS-EKS-orange)](https://aws.amazon.com/eks/)
[![Terraform](https://img.shields.io/badge/Terraform-1.0+-blueviolet)](https://www.terraform.io/)
[![Docker](https://img.shields.io/badge/Docker-20.10+-blue)](https://www.docker.com/)
[![Gradio](https://img.shields.io/badge/Gradio-5.0+-green)](https://gradio.app/)

![Architecture](./assets/flow.svg)

複数のGradioアプリケーションをAWS EKSクラスターで効率的に実行するサンプルプロジェクト

</div>

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

## 🆕 新しいアプリの追加方法

新しいGradioアプリケーションを追加する手順：

1. アプリケーションディレクトリの作成
```bash
mkdir -p apps/app{N}    # {N}は次のアプリ番号（例：app4）
```

2. アプリケーションの実装
```python
# apps/app{N}/app.py
import gradio as gr

# アプリケーションの実装
with gr.Blocks(title="新しいアプリ") as demo:
    # UIコンポーネントの追加
    pass

if __name__ == "__main__":
    demo.launch(server_name="0.0.0.0", server_port=7860)
```

3. k8s-deploymentsの更新
```yaml
# apps/k8s-deployments.yamlに以下を追加

# 新しいアプリ (App{N})
apiVersion: apps/v1
kind: Deployment
metadata:
  name: gradio-new-app
  labels:
    app: gradio-new-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: gradio-new-app
  template:
    metadata:
      labels:
        app: gradio-new-app
    spec:
      containers:
      - name: gradio-new-app
        image: ${ECR_REPOSITORY_URL}:new-app
        ports:
        - containerPort: 7860
        resources:
          requests:
            memory: "256Mi"
            cpu: "100m"
          limits:
            memory: "512Mi"
            cpu: "200m"
---
apiVersion: v1
kind: Service
metadata:
  name: gradio-new-app-service
spec:
  selector:
    app: gradio-new-app
  ports:
  - port: 80
    targetPort: 7860
  type: LoadBalancer
```

4. イメージのビルドとデプロイ
```bash
# ECRリポジトリURLの取得
ECR_REPOSITORY_URL=$(terraform -chdir=terraform output -raw ecr_repository_url)

# イメージのビルドとプッシュ
cd apps
docker build --build-arg APP_DIR=app{N} -t gradio-apps:new-app .
docker tag gradio-apps:new-app ${ECR_REPOSITORY_URL}:new-app
docker push ${ECR_REPOSITORY_URL}:new-app

# Kubernetesへのデプロイ
kubectl apply -f k8s-deployments.yaml
```

5. アプリケーションの確認
```bash
kubectl get service gradio-new-app-service
```
生成されたELBエンドポイントにアクセスして、アプリケーションの動作を確認してください。

### 🤖 自動デプロイスクリプトの使用

上記の手順をすべて自動化するスクリプトを用意しています：

```bash
# スクリプトに実行権限を付与
chmod +x apps/deploy.sh

# スクリプトを実行
# 使用方法: ./deploy.sh <アプリ番号> <アプリ名>
# 例: アプリ4（画像処理アプリ）を追加する場合
./apps/deploy.sh 4 image
```

スクリプトは以下の処理を自動的に実行します：

1. アプリケーションディレクトリの作成
2. AWS認証情報の確認
3. kubectlの設定更新
4. ECRへのログイン
5. Dockerイメージのビルドとプッシュ
6. Kubernetesマニフェストの適用
7. デプロイ状態の確認

スクリプト実行後、各サービスのエンドポイントが表示されます。

注意：新しいアプリを追加する際は、既存のアプリケーションの設計パターンに従い、
一貫性のある実装を心がけてください。また、リソース要求（CPU/メモリ）は
プロジェクトの標準に合わせて設定してください。

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
