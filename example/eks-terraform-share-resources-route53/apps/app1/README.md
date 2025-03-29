# カウンターアプリケーション 🔢

シンプルで使いやすいカウンターアプリケーションです。

## 🌟 機能

- カウントアップ機能
- リセット機能
- シンプルで直感的なUI

## 🛠️ 技術スタック

- Python 3.10+
- Gradio 5.0+
- Docker

## 💻 ローカルでの実行方法

1. 依存関係のインストール
```bash
pip install -r ../../requirements.txt
```

2. アプリケーションの起動
```bash
python app.py
```

アプリケーションは http://localhost:7860 でアクセスできます。

## 🧪 テスト実行

```bash
python -m pytest test_app.py
```

## 🐳 Dockerでの実行

1. イメージのビルド
```bash
docker build -t counter-app --build-arg APP_DIR=app1 ../
```

2. コンテナの実行
```bash
docker run -p 7860:7860 counter-app
```

## 📝 コードの説明

### メイン機能

```python
# カウントアップ機能
def increment():
    global count
    count += 1
    return f"現在のカウント: {count}"

# リセット機能
def reset():
    global count
    count = 0
    return f"現在のカウント: {count}"
```

## ⚙️ 設定可能なパラメータ

環境変数で以下の設定が可能です：
- `GRADIO_SERVER_PORT`: サーバーポート（デフォルト: 7860）
- `GRADIO_SERVER_NAME`: サーバーホスト名（デフォルト: 0.0.0.0）

## 🔍 注意事項

- グローバル変数を使用しているため、複数ユーザーでの使用には適していません
- プロダクション環境では、永続化機能の追加を検討してください
