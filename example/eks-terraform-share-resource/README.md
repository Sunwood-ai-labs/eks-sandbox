# EKS Shared Resources Sample 🚀

このプロジェクトは、AWS EKSクラスターに複数のGradioアプリケーションをデプロイするサンプルです。3つのシンプルなGradioアプリが同じEKSクラスター上で動作し、リソースを共有します。

## 📱 アプリケーション

1. **カウンターアプリ**
   - シンプルなカウンター機能
   - カウントアップとリセット機能

2. **計算機アプリ**
   - 基本的な四則演算
   - 直感的なインターフェース

3. **テキスト変換アプリ**
   - テキストの大文字/小文字変換
   - 文字の反転
   - スペースの除去

## 🛠️ 技術スタック

- AWS EKS
- Terraform
- Docker
- Kubernetes
- Gradio
- Python

## 📋 前提条件

- AWS CLI (設定済み)
- Terraform v1.0.0以上
- Docker
- kubectl

## 🚀 デプロイ手順

### 1. Terraformでインフラストラクチャを作成

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### 2. kubectlの設定

```bash
# Terraformの出力から設定コマンドを取得
terraform output configure_kubectl
```

### 3. Dockerイメージのビルドとプッシュ

各アプリケーションのイメージをビルドしてECRにプッシュ:

```bash
# ECRにログイン
eval $(terraform output docker_login_command)

# カウンターアプリ
cd ../apps
docker build --build-arg APP_DIR=app1 -t gradio-apps:counter .
docker tag gradio-apps:counter $(terraform output -raw ecr_repository_url):counter
docker push $(terraform output -raw ecr_repository_url):counter

# 計算機アプリ
docker build --build-arg APP_DIR=app2 -t gradio-apps:calculator .
docker tag gradio-apps:calculator $(terraform output -raw ecr_repository_url):calculator
docker push $(terraform output -raw ecr_repository_url):calculator

# テキスト変換アプリ
docker build --build-arg APP_DIR=app3 -t gradio-apps:text .
docker tag gradio-apps:text $(terraform output -raw ecr_repository_url):text
docker push $(terraform output -raw ecr_repository_url):text
```

### 4. Kubernetesにデプロイ

```bash
kubectl apply -f apps/k8s-deployments.yaml
```

### 5. アプリケーションのアクセス

```bash
# 各サービスのエンドポイントを取得
kubectl get service

# ブラウザで各エンドポイントにアクセス
```

## 📝 設定のカスタマイズ

- `terraform/variables.tf`: クラスター設定のカスタマイズ
- `apps/k8s-deployments.yaml`: Kubernetesリソースの設定
- `apps/*/app.py`: 各アプリケーションのコード

## 🔄 ノードとPodの配置最適化

### リソース使用状況
現在の3つのアプリケーションの実行に必要なリソース:
- 合計CPU要求: 300m (100m × 3アプリ)
- 合計メモリ要求: 768Mi (256Mi × 3アプリ)

### 現在のPodの配置
```bash
# Podの配置状況を確認
kubectl get pods -o wide
```

現在は全てのPodが同一ノード上で実行されています:
- カウンターアプリ (gradio-counter-app) → ip-10-0-1-7
- 計算機アプリ (gradio-calculator-app) → ip-10-0-1-7
- テキスト変換アプリ (gradio-text-app) → ip-10-0-1-7

これは現在の負荷が低く、1つのノードで十分に処理できるためです。

### 推奨ノード設定
`terraform/variables.tf`での推奨設定:
```hcl
node_desired_capacity = 1  # 通常時は1台で運用
node_max_capacity     = 3  # 負荷増大時に備えて最大3台まで
node_min_capacity     = 1  # 最小1台を維持
```

この設定の利点:
- コスト効率の向上（使用していないノードの削減）
- 必要時のみスケールアウトする柔軟な構成
- 1台のt3.medium（2vCPU, 4GB RAM）で十分な現在の負荷に対する適切な対応

## 🧹 クリーンアップ

```bash
# アプリケーションの削除
kubectl delete -f apps/k8s-deployments.yaml

# インフラストラクチャの削除
cd terraform
terraform destroy
```

## ⚠️ 注意事項

- これはデモ用のサンプルプロジェクトです
- 本番環境では適切なセキュリティ設定を行ってください
- 使用後は必ずリソースを削除して、不要な課金を防いでください

## 📚 参考リンク

- [AWS EKSドキュメント](https://docs.aws.amazon.com/eks/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Gradio Documentation](https://gradio.app/docs/)
