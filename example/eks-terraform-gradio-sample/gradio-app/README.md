<div align="center">

# シンプルなGradioアプリ 🎨

[![Python](https://img.shields.io/badge/Python-3.10-blue)](https://www.python.org/)
[![Gradio](https://img.shields.io/badge/Gradio-5.x-orange)](https://gradio.app/)
[![Docker](https://img.shields.io/badge/Docker-Ready-blue)](https://www.docker.com/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-EKS-blue)](https://aws.amazon.com/eks/)

EKSにデプロイするためのシンプルなGradioアプリケーションです。

<img src="./example_sketch.png" alt="Application Screenshot" width="600"/>

</div>

## 📚 目次
- [📚 目次](#-目次)
- [🌟 アプリケーションの概要](#-アプリケーションの概要)
- [🚀 ローカルでの開発](#-ローカルでの開発)
  - [必要条件](#必要条件)
  - [ローカルでの実行方法](#ローカルでの実行方法)
- [📁 ファイル構成](#-ファイル構成)
- [🛠️ 技術スタック](#️-技術スタック)
- [🔧 トラブルシューティング](#-トラブルシューティング)
  - [Gradio 5.xのインストールエラー](#gradio-5xのインストールエラー)
- [📦 デプロイ手順](#-デプロイ手順)
- [📝 注意事項](#-注意事項)

## 🌟 アプリケーションの概要

シンプルな挨拶を返すWebアプリケーションです。名前を入力すると「こんにちは、〇〇さん！」というメッセージを返します。

## 🚀 ローカルでの開発

### 必要条件

- Docker
- Docker Compose

### ローカルでの実行方法

1. リポジトリをクローンします：
```bash
git clone <repository-url>
cd gradio-app
```

2. Docker Composeでアプリを起動します：
```bash
docker compose up --build
```

3. ブラウザで以下のURLにアクセスします：
```
http://localhost:7860
```

<div align="center">
<img src="./example_sketch.png" alt="Local Development" width="400"/>
</div>

## 📁 ファイル構成

- `app.py` - Gradioアプリケーションのメインコード
- `requirements.txt` - Pythonの依存関係
- `Dockerfile` - コンテナイメージのビルド設定
- `docker-compose.yml` - ローカル開発用の設定
- `k8s-deployment.yaml` - Kubernetes用のデプロイメント設定

## 🛠️ 技術スタック

- Python 3.10
- Gradio 5.x
- Docker
- Kubernetes (EKS)

## 🔧 トラブルシューティング

### Gradio 5.xのインストールエラー
Python 3.10以上が必要です。Dockerfileで適切なPythonバージョンを指定していることを確認してください。

## 📦 デプロイ手順

1. イメージのビルド：
```bash
docker build -t gradio-app:latest .
```

2. イメージのタグ付け：
```bash
docker tag gradio-app:latest <your-registry>/gradio-app:latest
```

3. イメージのプッシュ：
```bash
docker push <your-registry>/gradio-app:latest
```

4. Kubernetesへのデプロイ：
```bash
kubectl apply -f k8s-deployment.yaml
```

## 📝 注意事項

- 本番環境にデプロイする際は、適切なセキュリティ設定を行ってください。
- 環境変数やシークレットは適切に管理してください。
- リソースの制限値は必要に応じて調整してください。
