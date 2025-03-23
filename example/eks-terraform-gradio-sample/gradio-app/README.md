# シンプルなGradioアプリ

EKSにデプロイするためのシンプルなGradioアプリケーションです。

## アプリケーションの概要

シンプルな挨拶を返すWebアプリケーションです。名前を入力すると「こんにちは、〇〇さん！」というメッセージを返します。

## ローカルでの開発

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

## ファイル構成

- `app.py` - Gradioアプリケーションのメインコード
- `requirements.txt` - Pythonの依存関係
- `Dockerfile` - コンテナイメージのビルド設定
- `docker-compose.yml` - ローカル開発用の設定
- `k8s-deployment.yaml` - Kubernetes用のデプロイメント設定

## 技術スタック

- Python 3.10
- Gradio 5.x
- Docker
- Kubernetes (EKS)

## トラブルシューティング

### Gradio 5.xのインストールエラー
Python 3.10以上が必要です。Dockerfileで適切なPythonバージョンを指定していることを確認してください。

## デプロイ手順

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
