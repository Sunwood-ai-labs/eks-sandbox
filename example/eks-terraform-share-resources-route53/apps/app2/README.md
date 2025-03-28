# 計算機アプリケーション 🧮

シンプルで使いやすい四則演算計算機アプリケーションです。

## 🌟 機能

- 足し算
- 引き算
- 掛け算
- 割り算
- エラーハンドリング（0除算など）

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
docker build -t calculator-app --build-arg APP_DIR=app2 ../
```

2. コンテナの実行
```bash
docker run -p 7860:7860 calculator-app
```

## 📝 コードの説明

### メイン機能

```python
def calculate(num1, num2, operation):
    try:
        num1 = float(num1)
        num2 = float(num2)
        if operation == "足し算":
            return f"{num1} + {num2} = {num1 + num2}"
        elif operation == "引き算":
            return f"{num1} - {num2} = {num1 - num2}"
        elif operation == "掛け算":
            return f"{num1} × {num2} = {num1 * num2}"
        elif operation == "割り算":
            if num2 == 0:
                return "0で割ることはできません"
            return f"{num1} ÷ {num2} = {num1 / num2}"
    except ValueError:
        return "数値を入力してください"
```

## ⚙️ 設定可能なパラメータ

環境変数で以下の設定が可能です：
- `GRADIO_SERVER_PORT`: サーバーポート（デフォルト: 7860）
- `GRADIO_SERVER_NAME`: サーバーホスト名（デフォルト: 0.0.0.0）

## 🔍 エラーハンドリング

アプリケーションは以下のエラーを適切に処理します：
- 数値以外の入力
- 0による除算
- 無効な演算子

## ✨ 特徴

- シンプルで直感的なUI
- 日本語表示で使いやすい
- リアルタイムの計算結果表示
- 堅牢なエラーハンドリング
