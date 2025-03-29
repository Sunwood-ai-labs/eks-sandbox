<div align="center">

![Image](https://github.com/user-attachments/assets/3585a45e-f7cd-43a2-b9b4-1c4fb57d5ca0)

# EKS Shared Resources with Auto Deploy 🚀

[![AWS](https://img.shields.io/badge/AWS-EKS-orange?style=for-the-badge&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/eks/)
[![Terraform](https://img.shields.io/badge/Terraform-1.0+-blueviolet?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Docker](https://img.shields.io/badge/Docker-20.10+-blue?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![Gradio](https://img.shields.io/badge/Gradio-5.0+-green?style=for-the-badge&logo=python&logoColor=white)](https://gradio.app/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-1.28-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)](https://kubernetes.io/)

複数のGradioアプリケーションをAWS EKSクラスターで効率的に実行し、自動デプロイを実現するサンプルプロジェクト

</div>

## 📑 目次
- [📑 目次](#-目次)
- [📱 概要](#-概要)
- [🔄 自動デプロイワークフロー](#-自動デプロイワークフロー)
- [🆕 新しいアプリの追加方法](#-新しいアプリの追加方法)
  - [手動プロセス](#手動プロセス)
  - [🤖 自動デプロイスクリプトの使用](#-自動デプロイスクリプトの使用)
- [🛠️ 技術スタック](#️-技術スタック)
- [📋 前提条件](#-前提条件)
- [🚀 デプロイ手順](#-デプロイ手順)
- [📊 アプリケーションの管理](#-アプリケーションの管理)
- [⚙️ リソースの最適化](#️-リソースの最適化)
  - [現在の設定](#現在の設定)
  - [推奨ノード設定](#推奨ノード設定)
  - [スケーリングの考え方](#スケーリングの考え方)
- [🛡️ セキュリティ考慮事項](#️-セキュリティ考慮事項)
- [📈 モニタリングとログ](#-モニタリングとログ)
- [🔄 CI/CDパイプラインとの統合](#-cicdパイプラインとの統合)
- [🧹 クリーンアップ](#-クリーンアップ)
- [❓ トラブルシューティング](#-トラブルシューティング)
- [⚠️ 注意事項](#️-注意事項)

## 📱 概要

このプロジェクトは、複数のGradioアプリケーションを単一のEKSクラスターにデプロイし、新しいアプリケーションを簡単に追加できる自動デプロイ機能を備えています。現在、以下のアプリケーションが含まれています：

- **カウンターアプリ**: シンプルなカウントアップとリセット機能
- **計算機アプリ**: 基本的な四則演算機能
- **テキスト変換アプリ**: テキストの大文字/小文字変換、反転機能
- **画像処理アプリ**: グレースケール変換、ぼかし効果の適用

## 🔄 自動デプロイワークフロー

このプロジェクトの自動デプロイワークフローは以下のように設計されています：

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│                 │     │                 │     │                 │
│  新アプリ作成   │────►│  Dockerイメージ  │────►│    ECRプッシュ   │
│                 │     │   ビルド        │     │                 │
└─────────────────┘     └─────────────────┘     └────────┬────────┘
                                                         │
                                                         ▼
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│                 │     │                 │     │                 │
│  完了通知       │◄────│ デプロイ状態確認 │◄────│  K8sマニフェスト │
│                 │     │                 │     │   適用          │
└─────────────────┘     └─────────────────┘     └─────────────────┘
```

## 🆕 新しいアプリの追加方法

### 手動プロセス

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
# 例: アプリ5（音声処理アプリ）を追加する場合
./apps/deploy.sh 5 audio
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

## 🛠️ 技術スタック

- **AWS EKS**: Kubernetesクラスターの管理サービス
- **AWS ECR**: コンテナレジストリサービス
- **Terraform**: インフラストラクチャのコード化ツール
- **Docker**: アプリケーションのコンテナ化技術
- **Kubernetes**: コンテナオーケストレーションプラットフォーム
- **Gradio**: Pythonベースのウェブアプリケーションフレームワーク
- **Bash/Shell**: 自動化スクリプト

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
terraform plan   # 変更内容の確認
terraform apply  # インフラのデプロイ
```

3. kubectlの設定
```bash
aws eks update-kubeconfig --name $(terraform output -raw cluster_id) --region $(terraform output -raw region)
```

4. アプリケーションのビルドとデプロイ
```bash
# ECRログイン
eval $(terraform output -raw docker_login_command)

# アプリケーションのビルドとプッシュ（全アプリケーションのデプロイ）
cd ../apps
./deploy.sh all
```

5. アプリケーションのアクセス
```bash
kubectl get service
# 各サービスのELBエンドポイントにアクセス
```

## 📊 アプリケーションの管理

### スケーリング設定

各アプリケーションは個別にスケーリングできます：

```bash
# レプリカ数の増減
kubectl scale deployment gradio-counter-app --replicas=3

# HPA (Horizontal Pod Autoscaler) の設定
kubectl autoscale deployment gradio-calculator-app --cpu-percent=80 --min=1 --max=5
```

### ヘルスチェック

```bash
# ポッドの健全性確認
kubectl get pods
kubectl describe pod <pod-name>

# ログの確認
kubectl logs <pod-name>
```

### アプリケーションの更新

```bash
# イメージの更新
docker build --build-arg APP_DIR=app1 -t gradio-apps:counter-v2 .
docker tag gradio-apps:counter-v2 ${ECR_REPOSITORY_URL}:counter
docker push ${ECR_REPOSITORY_URL}:counter

# デプロイメントのリスタート
kubectl rollout restart deployment gradio-counter-app
```

## ⚙️ リソースの最適化

### 現在の設定

- 各アプリケーションのリソース要求:
  - CPU: 100m
  - メモリ: 256Mi
  - リミット: CPU 200m, メモリ 512Mi

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

## 🛡️ セキュリティ考慮事項

このサンプルプロジェクトを本番環境で使用する場合、以下のセキュリティ対策を検討してください：

1. **ネットワークセキュリティ**
   - プライベートサブネットでのEKSノード実行
   - セキュリティグループの最小権限設定
   - VPC間トラフィックの暗号化

2. **アクセス制御**
   - RBAC（Role-Based Access Control）の設定
   - IAMロールの最小権限原則
   - Kubernetes Service Accountとの連携

3. **機密情報管理**
   - Kubernetes Secretsの利用
   - AWS Secrets Managerとの統合
   - 環境変数の暗号化

4. **コンプライアンスと監査**
   - CloudTrailログの有効化
   - EKSログの集中管理
   - Kubernetes監査ログの設定

## 📈 モニタリングとログ

### EKSクラスターのモニタリング

```bash
# CloudWatch Containter Insightsの有効化
aws eks update-cluster-config \
    --name $CLUSTER_NAME \
    --region $AWS_REGION \
    --logging '{"clusterLogging":[{"types":["api","audit","authenticator","controllerManager","scheduler"],"enabled":true}]}'

# Prometheusのデプロイ（オプション）
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prometheus prometheus-community/kube-prometheus-stack
```

### アプリケーションログの確認

```bash
# ポッドのログ取得
kubectl logs -f deployment/gradio-counter-app

# 過去のログを確認（再起動後も）
kubectl logs --previous pod/<pod-name>
```

## 🔄 CI/CDパイプラインとの統合

このプロジェクトは、以下のようなCI/CDパイプラインと簡単に統合できます：

### GitHub Actionsの例

```yaml
name: Deploy Gradio App

on:
  push:
    branches: [ main ]
    paths:
      - 'apps/**'

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ap-northeast-1
      
      - name: Login to Amazon ECR
        id: login-ecr
        uses: aws-actions/amazon-ecr-login@v1
      
      - name: Build and push Docker image
        env:
          ECR_REPOSITORY: ${{ steps.login-ecr.outputs.registry }}/gradio-apps
        run: |
          cd apps
          docker build --build-arg APP_DIR=app1 -t $ECR_REPOSITORY:counter .
          docker push $ECR_REPOSITORY:counter
      
      - name: Update kubeconfig
        run: |
          aws eks update-kubeconfig --name eks-shared-cluster --region ap-northeast-1
      
      - name: Deploy to Kubernetes
        run: |
          kubectl rollout restart deployment gradio-counter-app
```

## 🧹 クリーンアップ

```bash
# アプリケーションの削除
kubectl delete -f apps/k8s-deployments.yaml

# インフラの削除
cd terraform
terraform destroy
```

## ❓ トラブルシューティング

### よくある問題と解決方法

| 問題 | 考えられる原因 | 解決策 |
|------|--------------|--------|
| Terraformのエラー | AWS認証情報の問題 | `aws configure`で認証情報を確認 |
| | 依存関係の欠如 | `terraform init`を再実行 |
| | 既存リソースの衝突 | 既存リソースを確認し調整 |
| イメージのプッシュ失敗 | ECR認証の期限切れ | `aws ecr get-login-password`を再実行 |
| | イメージタグのミス | タグ名を確認 |
| ポッドの起動失敗 | リソース不足 | ノード数や規模を増加 |
| | イメージプル失敗 | イメージの存在とパスを確認 |
| アプリケーションへのアクセス失敗 | ロードバランサーの設定 | セキュリティグループを確認 |
| | サービスの設定ミス | ポート設定を確認 |

### デバッグコマンド

```bash
# クラスター情報の確認
kubectl cluster-info
kubectl get nodes -o wide

# ポッドの詳細情報
kubectl describe pod <pod-name>

# サービスの詳細
kubectl describe service <service-name>

# イベントの確認
kubectl get events --sort-by='.lastTimestamp'
```

## ⚠️ 注意事項

- このプロジェクトはデモ用のサンプルです
- 本番環境では適切なセキュリティ設定を行ってください
- リソースリミットと要求を適切に設定して過剰課金を防止してください
- 使用後は必ずリソースを削除してください
- 新しいアプリを追加する際は、既存のアプリケーションの設計パターンに従い、一貫性のある実装を心がけてください
