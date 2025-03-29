<div align="center">

![Image](https://github.com/user-attachments/assets/0f03897e-a242-4265-a857-2cc83532a60b)

# EKS-Sample Project Repository 🚀

このリポジトリは、AWS EKSに関連するサンプルプロジェクトを集めたものです。

[![AWS EKS](https://img.shields.io/badge/AWS-EKS-FF9900?style=for-the-badge&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/eks/)
[![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![Python](https://img.shields.io/badge/Python-3.10-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](LICENSE)

</div>

## 📦 サンプルプロジェクト

### 🌟 [EKS Terraform Gradio Sample](./example/eks-terraform-gradio-sample/)
TerraformでAWS EKSクラスターを構築し、シンプルなGradioアプリケーションをデプロイするサンプルプロジェクトです。

<div align="center">
<img src="./example/eks-terraform-gradio-sample/asset/flow.svg" alt="Architecture" width="600"/>
</div>

#### ✨ 主な機能
- 🏗️ Terraformを使用したEKSクラスターの構築
- 🐳 Gradioアプリケーションのコンテナ化とデプロイ
- 🤖 完全な自動化されたインフラストラクチャ

[➡️ プロジェクトの詳細を見る](./example/eks-terraform-gradio-sample/)

### 🌟 [EKS Terraform Shared Resources](./example/eks-terraform-share-resource/)
複数のGradioアプリケーションを同一のEKSクラスター上でホストするサンプルプロジェクトです。リソースの共有とコスト最適化の例を示しています。

#### ✨ 主な機能
- 🏗️ 単一のEKSクラスターで複数アプリケーションを実行
- 🔄 カウンターアプリ、計算機アプリ、テキスト変換アプリの3種類のデモアプリを提供
- 💰 共有インフラによるコスト効率の最適化
- 🔧 スケーリング設定のベストプラクティス

[➡️ プロジェクトの詳細を見る](./example/eks-terraform-share-resource/)

### 🌟 [EKS Terraform with Route53 Integration](./example/eks-terraform-share-resources-route53/)
EKSクラスター、Route53 DNSサービス、ACM証明書を統合した高度なサンプルプロジェクトです。カスタムドメインとHTTPSを使用したサービス提供の例を示しています。

#### ✨ 主な機能
- 🔒 ACM証明書を用いたHTTPS対応
- 🌐 Route53によるカスタムドメイン設定
- 📝 包括的なテストとドキュメント
- 🔄 Linux/macOSとWindows両方に対応したデプロイスクリプト

[➡️ プロジェクトの詳細を見る](./example/eks-terraform-share-resources-route53/)

### 🌟 [EKS Shared Resources with Auto Deploy](./example/eks-shared-resources-auto-deploy/)
CI/CDパイプラインを模した自動デプロイ機能を備えたEKSサンプルプロジェクトです。新しいアプリケーションの追加と自動デプロイのワークフローを示しています。

#### ✨ 主な機能
- 🚀 新しいアプリケーションの簡単な追加と自動デプロイ
- 📊 リソース使用量の最適化設定
- 🔄 複数のGradioアプリケーションの管理
- 🛠️ 包括的なデプロイスクリプトとユーティリティ

[➡️ プロジェクトの詳細を見る](./example/eks-shared-resources-auto-deploy/)

## 🌟 プロジェクト比較

| プロジェクト | 主な特徴 | 難易度 | ユースケース |
|------------|--------|--------|------------|
| [eks-terraform-gradio-sample](./example/eks-terraform-gradio-sample/) | 単一アプリ、シンプルな構成 | 初級 | 初めてのEKS/Terraform構築 |
| [eks-terraform-share-resource](./example/eks-terraform-share-resource/) | 複数アプリ、リソース共有 | 中級 | マルチアプリケーション環境 |
| [eks-terraform-share-resources-route53](./example/eks-terraform-share-resources-route53/) | DNS統合、SSL/TLS証明書 | 上級 | 本番環境向けセットアップ |
| [eks-shared-resources-auto-deploy](./example/eks-shared-resources-auto-deploy/) | 自動デプロイ、CI/CD | 中級 | DevOpsワークフロー |

## 🚀 使用方法

各サンプルプロジェクトは独立して機能し、それぞれのディレクトリに詳細なREADMEが含まれています。以下は一般的な使用手順です：

1. 目的に合ったサンプルプロジェクトを選択
2. 対応するREADMEに記載された前提条件を確認
3. `.env.example`をコピーして`.env`ファイルを作成し、必要な情報を設定
4. プロジェクトディレクトリで`terraform init`および`terraform apply`を実行
5. 各プロジェクトのデプロイスクリプトに従ってアプリケーションをデプロイ

## 🔮 追加予定のサンプル
- 🚀 EKS Fargateサンプル
- 📊 EKS with Kubeflowサンプル
- 📈 EKS with Grafanaサンプル

## 📝 ライセンス
MITライセンスで提供されています。詳細は[LICENSE](./LICENSE)をご覧ください。
