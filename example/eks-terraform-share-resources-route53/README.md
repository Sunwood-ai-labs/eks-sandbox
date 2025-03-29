<div align="center">

![Image](https://github.com/user-attachments/assets/fd170d5c-8df4-4261-8e45-bd8e7a9a1511)

# EKS with Route53 & ACM Integration 🚀

[![AWS](https://img.shields.io/badge/AWS-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)](https://aws.amazon.com/)
[![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)](https://kubernetes.io/)

</div>

## 📑 目次

- [📑 目次](#-目次)
- [📚 プロジェクトドキュメント](#-プロジェクトドキュメント)
- [📊 アーキテクチャ概要](#-アーキテクチャ概要)
- [📱 機能概要](#-機能概要)
- [🛠️ 技術スタック](#️-技術スタック)
- [📋 前提条件](#-前提条件)
- [🚀 デプロイ手順](#-デプロイ手順)
  - [Linux/macOSでのデプロイ](#linuxmacosでのデプロイ)
  - [Windowsでのデプロイ](#windowsでのデプロイ)
  - [デプロイ後の確認](#デプロイ後の確認)
- [⚙️ リソースの最適化](#️-リソースの最適化)
  - [現在の設定](#現在の設定)
  - [推奨ノード設定](#推奨ノード設定)
  - [スケーリングの考え方](#スケーリングの考え方)
- [🔄 CI/CDパイプラインとの統合](#-cicdパイプラインとの統合)
- [📝 カスタマイズ方法](#-カスタマイズ方法)
- [🧪 テスト方法](#-テスト方法)
- [🧹 クリーンアップ](#-クリーンアップ)
- [🔍 トラブルシューティング](#-トラブルシューティング)
- [⚠️ 注意事項](#️-注意事項)

## 📚 プロジェクトドキュメント

### インフラストラクチャ
- [Terraformリソース設定](./terraform/README.md) - インフラ構成の詳細説明

### アプリケーション
- [アプリケーション概要](./apps/README.md) - 全アプリケーション共通情報
  - [カウンターアプリ](./apps/app1/README.md) - シンプルなカウンター機能
  - [計算機アプリ](./apps/app2/README.md) - 四則演算計算機
  - [テキスト変換アプリ](./apps/app3/README.md) - テキスト変換ユーティリティ

## 📊 アーキテクチャ概要

このプロジェクトは以下のAWSサービスを連携させた高度なアーキテクチャを実現しています：

```
                                    ┌─────────────────┐
                                    │                 │
                                    │  Route53 Zone   │
                                    │                 │
                                    └───────┬─────────┘
                                            │
                                            ▼
┌─────────────────┐              ┌─────────────────┐
│                 │              │                 │
│  ACM Certificate│◄─────────────│  DNS Validation │
│                 │              │                 │
└───────┬─────────┘              └─────────────────┘
        │
        ▼
┌─────────────────┐              ┌─────────────────┐
│   Application   │              │                 │
│  Load Balancer  │◄─────────────│  EKS Cluster    │
│     (NLB)       │              │                 │
└───────┬─────────┘              └─────────────────┘
        │                                 ▲
        ▼                                 │
┌─────────────────┐              ┌────────┴────────┐
│  Custom Domains │              │  ECR Repository │
│  with HTTPS     │              │  (Docker Images)│
└─────────────────┘              └─────────────────┘
```

## 📱 機能概要

このプロジェクトでは、複数のGradioアプリケーションを単一のEKSクラスター上でホストし、以下の高度な設定を実現しています：

- **カスタムドメイン設定**: Route53を使用して各アプリケーションに独自のサブドメインを割り当て
- **SSL/TLS対応**: ACM証明書を使用したHTTPS通信の実現
- **セキュアなネットワーク**: プライベートサブネットでのワークロード実行
- **クロスプラットフォーム対応**: Linux/macOSとWindows両方に対応したデプロイスクリプト
- **テスト自動化**: 各アプリケーションの単体テスト実装

デプロイされる3つのアプリケーションは以下のサブドメインでアクセス可能になります：
- カウンターアプリ: `https://counter.your-domain.com`
- 計算機アプリ: `https://calculator.your-domain.com`  
- テキスト変換アプリ: `https://text.your-domain.com`

## 🛠️ 技術スタック

- **AWS EKS**: Kubernetesクラスターの管理
- **AWS Route53**: DNS管理とカスタムドメイン設定
- **AWS ACM**: SSL/TLS証明書管理
- **AWS ECR**: コンテナイメージのプライベートレジストリ
- **Terraform**: インフラストラクチャのコード化
- **Docker**: アプリケーションのコンテナ化
- **Python/Gradio**: Webアプリケーションフレームワーク
- **Kubernetes**: コンテナオーケストレーション

## 📋 前提条件

- AWS CLI (設定済み)
- Terraform v1.0.0以上
- Docker
- kubectl
- 所有しているRoute53ドメイン（または設定可能なドメイン）

## 🚀 デプロイ手順

### Linux/macOSでのデプロイ

1. リポジトリのクローンとディレクトリ移動
```bash
git clone <repository-url>
cd eks-terraform-share-resources-route53
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

### Windowsでのデプロイ

1. リポジトリのクローンとディレクトリ移動
```powershell
git clone <repository-url>
cd eks-terraform-share-resources-route53
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

### デプロイ後の確認

1. Kubernetesリソースの確認
```bash
kubectl get pods     # Podの状態確認
kubectl get service  # LoadBalancerのエンドポイント確認
```

2. DNS設定の確認
```bash
dig counter.<your-domain>    # DNSレコードの確認
dig calculator.<your-domain> # DNSレコードの確認
dig text.<your-domain>       # DNSレコードの確認
```

3. アプリケーションへのアクセス
以下のURLにブラウザからアクセスして動作確認：
- `https://counter.<your-domain>`
- `https://calculator.<your-domain>`
- `https://text.<your-domain>`

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

- **通常時**: 1ノードで十分な処理が可能（t3.mediumインスタンス）
- **負荷増大時**: 自動でスケールアウト（最大3ノード）
- **コスト最適化**: 不要なノードは自動削除
- **リソース配分**: 複数アプリケーションのバランスを考慮

## 🔄 CI/CDパイプラインとの統合

このプロジェクトは以下のようなCI/CDパイプラインとの統合が可能です：

1. **インフラ更新フロー**:
   - GitリポジトリへのPush
   - Terraform Planの自動実行（GitHub Actions/Jenkins）
   - コードレビュー後、承認プロセス
   - Terraform Applyの実行

2. **アプリケーション更新フロー**:
   - アプリケーションコードの変更
   - 自動テストの実行
   - ECRへのイメージビルドとプッシュ
   - Kubernetesマニフェストの更新とデプロイ

## 📝 カスタマイズ方法

### 新しいアプリケーションの追加

1. `apps/app{N}` ディレクトリを作成
2. アプリケーションコードと単体テストを追加
3. `k8s-deployments.yaml` に新しいデプロイメント定義を追加
4. `terraform/route53.tf` に新しいDNSレコード設定を追加
5. デプロイスクリプトを実行

### ドメイン設定の変更

1. `terraform/terraform.tfvars` ファイルを編集
```hcl
domain = "your-new-domain.com"
route53_zone_id = "YOUR_ZONE_ID"
```

2. Terraformを再適用
```bash
terraform apply
```

## 🧪 テスト方法

各アプリケーションのテストは以下のコマンドで実行できます：

```bash
cd apps/app1
python -m pytest test_app.py

cd ../app2
python -m pytest test_app.py

cd ../app3
python -m pytest test_app.py
```

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

## 🔍 トラブルシューティング

### 一般的な問題と解決策

1. **DNS設定が反映されない**
   - TTL値を確認し、15分程度待機
   - Route53ホストゾーン設定を確認
   - ACM証明書のDNS検証が完了しているか確認

2. **SSL証明書のエラー**
   - ACM証明書がNLBと正しく関連付けられているか確認
   - 証明書のドメイン名と設定したドメインが一致するか確認

3. **Pod起動エラー**
   - `kubectl describe pod <pod-name>` でイベントを確認
   - `kubectl logs <pod-name>` でログを確認
   - イメージのプッシュとタグが正しいか確認

4. **ロードバランサー接続エラー**
   - セキュリティグループの設定を確認
   - ヘルスチェックの状態を確認
   - サブネットタグが正しく設定されているか確認

5. **Terraformエラー**
   - 実行ディレクトリが正しいか確認
   - AWS認証情報が正しく設定されているか確認
   - 依存関係のリソースが存在するか確認

## ⚠️ 注意事項

- このプロジェクトはデモ用のサンプルです
- 本番環境では以下の点を考慮してください：
  - IAMポリシーの最小権限原則に基づく設定
  - セキュリティグループの適切な設定
  - リソースモニタリングとアラートの設定
  - バックアップ戦略の実装
  - 環境分離（開発/ステージング/本番）
- 使用後は必ずリソースを削除してください
- このサンプルは教育目的です。本番環境向けには追加の調整が必要です
