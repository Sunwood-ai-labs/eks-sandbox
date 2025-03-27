# Gradio Applications 🎨

このディレクトリには3つのGradioアプリケーションが含まれています。

## 📱 アプリケーション一覧

### 1. カウンターアプリ (app1) 🔢
- シンプルなカウントアップ機能
- リセット機能
- [詳細はこちら](./app1/README.md)

### 2. 計算機アプリ (app2) 🧮
- 四則演算機能
- エラーハンドリング
- [詳細はこちら](./app2/README.md)

### 3. テキスト変換アプリ (app3) 📝
- テキストの大文字/小文字変換
- テキストの反転機能
- [詳細はこちら](./app3/README.md)

## 🚀 デプロイ方法

### 環境変数の設定
1. ルートディレクトリの`.env.example`をコピーして`.env`を作成
2. 必要な環境変数を設定

### Dockerイメージのビルドとプッシュ
- Linux/macOS: `./deploy.sh`を実行
- Windows: `./deploy.ps1`を実行

## 🔧 開発環境のセットアップ

```bash
# 仮想環境の作成と有効化
python -m venv venv
source venv/bin/activate  # Windows: .\venv\Scripts\activate

# 依存関係のインストール
pip install -r requirements.txt
```

## 🧪 テスト実行

各アプリケーションディレクトリで以下を実行：
```bash
python -m pytest test_app.py
