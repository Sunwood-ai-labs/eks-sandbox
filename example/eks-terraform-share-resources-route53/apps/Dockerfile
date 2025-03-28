FROM python:3.10-slim

WORKDIR /app

# 共通の依存関係をインストール
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 引数でアプリケーションディレクトリを指定できるようにする
ARG APP_DIR=app1
COPY ${APP_DIR}/app.py .

EXPOSE 7860

CMD ["python", "app.py"]
