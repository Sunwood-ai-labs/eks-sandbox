# テキスト変換アプリケーション 📝

多機能なテキスト変換アプリケーションです。

## 🌟 機能

- 大文字変換
- 小文字変換
- テキスト反転
- スペース除去

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
docker build -t text-app --build-arg APP_DIR=app3 ../
```

2. コンテナの実行
```bash
docker run -p 7860:7860 text-app
```

## 📝 コードの説明

### メイン機能

```python
def transform_text(text, transformation):
    if transformation == "大文字に変換":
        return text.upper()
    elif transformation == "小文字に変換":
        return text.lower()
    elif transformation == "逆さま文字":
        return text[::-1]
    elif transformation == "スペース除去":
        return text.replace(" ", "")
    return text
```

## ⚙️ 設定可能なパラメータ

環境変数で以下の設定が可能です：
- `GRADIO_SERVER_PORT`: サーバーポート（デフォルト: 7860）
- `GRADIO_SERVER_NAME`: サーバーホスト名（デフォルト: 0.0.0.0）

## 🔍 機能詳細

### 大文字変換
- 入力テキストをすべて大文字に変換
- 例：`hello world` → `HELLO WORLD`

### 小文字変換
- 入力テキストをすべて小文字に変換
- 例：`HELLO WORLD` → `hello world`

### テキスト反転
- 入力テキストを逆順にする
- 例：`hello world` → `dlrow olleh`

### スペース除去
- 入力テキストからすべてのスペースを削除
- 例：`hello world` → `helloworld`

## ✨ 特徴

- シンプルで直感的なUI
- 日本語テキストにも対応
- リアルタイムのプレビュー表示
- 複数の変換オプション

## 📌 注意事項

- 大量のテキスト処理時はメモリ使用量に注意
- 特殊文字や絵文字の変換は想定外の結果になる可能性あり
