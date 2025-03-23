# EKS Terraform Gradio Sample

TerraformでEKSクラスターを作成し、Gradioアプリケーションをデプロイするサンプルプロジェクトです。

## 前提条件

- AWS CLI (設定済み)
- Terraform v1.0.0以上
- kubectl
- Docker

## プロジェクト構成

```
.
├── gradio-app/          # Gradioアプリケーション
└── terraform/           # EKSクラスター用Terraform設定
```

## デプロイ手順

### 1. EKSクラスターの作成

1. Terraformの初期化：
```bash
terraform init
```

2. 実行プランの確認：
```bash
terraform plan
```

3. インフラストラクチャのデプロイ：
```bash
terraform apply
```

4. kubectlの設定：
```bash
aws eks update-kubeconfig --name eks-sample-cluster --region ap-northeast-1
```

5. ノードの確認：
```bash
kubectl get nodes
```

### 2. Gradioアプリケーションのデプロイ

1. ECRへのログイン：
```bash
aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin [AWS_ACCOUNT_ID].dkr.ecr.ap-northeast-1.amazonaws.com
```

2. Dockerイメージのビルドとプッシュ：
```bash
cd gradio-app
docker build -t gradio-app:latest .
docker tag gradio-app:latest [AWS_ACCOUNT_ID].dkr.ecr.ap-northeast-1.amazonaws.com/gradio-app:latest
docker push [AWS_ACCOUNT_ID].dkr.ecr.ap-northeast-1.amazonaws.com/gradio-app:latest
```

3. Kubernetesマニフェストの適用：
```bash
kubectl apply -f k8s-deployment.yaml
```

4. サービスの確認：
```bash
kubectl get service gradio-app-service
```

## クリーンアップ

1. アプリケーションの削除：
```bash
kubectl delete -f k8s-deployment.yaml
```

2. EKSクラスターの削除：
```bash
terraform destroy
```

## 設定のカスタマイズ

- `variables.tf`: クラスター名やノードグループの設定を変更できます
- `vpc.tf`: VPCやサブネットの設定をカスタマイズできます
- `eks.tf`: EKSクラスターの詳細設定を変更できます

## トラブルシューティング

### ノードグループが作成されない場合
- VPCのサブネットタグを確認してください
- IAMロールの権限を確認してください

### アプリケーションがデプロイできない場合
- ECRのイメージパスが正しいか確認してください
- k8s-deployment.yamlのイメージ参照を確認してください

## デプロイメント出力例

### アプリケーションの再起動
```bash
# デプロイメントの再起動
kubectl rollout restart deployment gradio-app

# 再起動後の状態
deployment.apps/gradio-app restarted

NAME                          READY   STATUS        RESTARTS        AGE
gradio-app-675dbd69d5-x5mrc   1/1     Running       0               11s
gradio-app-9fbc54c68-kbf9k    1/1     Terminating   7 (6m50s ago)   13m
```


## 注意事項

- このプロジェクトはサンプルです。本番環境では適切なセキュリティ設定を行ってください。
- 不要な課金を防ぐため、使用後は必ずリソースを削除してください。
