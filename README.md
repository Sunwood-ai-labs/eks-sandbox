# EKS Terraform Gradio Sample 🚀

TerraformでAWS EKSクラスターを構築し、Gradioアプリケーションをデプロイするサンプルプロジェクトだよ！💪

## 概要 ✨

このプロジェクトでは以下のことができるの：
- Terraformを使ったEKSクラスターの構築
- シンプルなGradioアプリケーションのデプロイ
- スケッチを画像に変換するデモアプリの実行

## 前提条件 📋

以下のツールが必要だよ：

- [AWS CLI](https://aws.amazon.com/cli/) （設定済みのもの）
- [Terraform](https://www.terraform.io/downloads.html) (v1.0.0以上)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Docker](https://www.docker.com/get-started)

## プロジェクト構成 📁

```plaintext
.
├── gradio-app/              # Gradioアプリケーション
│   ├── app.py              # アプリケーションコード
│   ├── Dockerfile          # コンテナ化設定
│   ├── k8s-deployment.yaml # Kubernetes設定
│   └── requirements.txt    # Pythonパッケージ依存関係
├── eks.tf                  # EKSクラスター設定
├── main.tf                 # メインのTerraform設定
├── outputs.tf              # 出力設定
├── providers.tf            # プロバイダー設定
├── terraform.tf            # バックエンド設定
├── variables.tf            # 変数定義
└── vpc.tf                  # VPCネットワーク設定
```

## EKSクラスターのセットアップ 🛠️

### 1. Terraformの初期化

```bash
terraform init
```

### 2. 実行プランの確認

```bash
terraform plan
```

### 3. インフラのデプロイ

```bash
terraform apply
```

### 4. kubectlの設定

```bash
aws eks update-kubeconfig --name eks-sample-cluster --region ap-northeast-1
```

## Gradioアプリケーションのデプロイ 🎨

### 1. ECRリポジトリの作成

```bash
aws ecr create-repository --repository-name gradio-app --region ap-northeast-1
```

### 2. Dockerイメージのビルドとプッシュ

```bash
cd gradio-app

# ECRにログイン
aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin $(aws sts get-caller-identity --query Account --output text).dkr.ecr.ap-northeast-1.amazonaws.com

# イメージのビルド
docker build -t gradio-app .

# イメージのタグ付け
docker tag gradio-app:latest $(aws sts get-caller-identity --query Account --output text).dkr.ecr.ap-northeast-1.amazonaws.com/gradio-app:latest

# イメージのプッシュ
docker push $(aws sts get-caller-identity --query Account --output text).dkr.ecr.ap-northeast-1.amazonaws.com/gradio-app:latest
```

### 3. k8s-deployment.yamlの更新

AWS_ACCOUNT_IDとAWS_REGIONを実際の値に置き換えてね！

### 4. アプリケーションのデプロイ

```bash
kubectl apply -f k8s-deployment.yaml
```

### 5. サービスのURLの取得

```bash
kubectl get service gradio-app-service
```

表示されたEXTERNAL-IPにアクセスしてアプリケーションを使ってみてね！✨

## クリーンアップ 🧹

1. アプリケーションの削除

```bash
kubectl delete -f k8s-deployment.yaml
```

2. EKSクラスターの削除

```bash
terraform destroy
```

## 注意事項 ⚠️

- このプロジェクトはデモ用だよ！本番環境で使う場合は、セキュリティとスケーラビリティをちゃんと考えてね！
- コストがかかる可能性があるから、使わないリソースはちゃんと削除してね！

## 問題が発生したら 🆘

1. エラーメッセージをよく確認してね
2. AWS CloudWatchログでEKSクラスターのログを確認してみて
3. `kubectl describe` コマンドでPodやServiceの状態を確認してね
