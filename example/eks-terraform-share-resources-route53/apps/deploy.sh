#!/bin/bash

# 環境変数の確認
if [ -z "$ECR_REPOSITORY_URL" ]; then
    echo "Error: ECR_REPOSITORY_URL environment variable is not set"
    exit 1
fi

# AWS ECRへのログイン
aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin $ECR_REPOSITORY_URL

# アプリケーションのビルドとプッシュ
apps=("counter" "calculator" "text")
for app in "${apps[@]}"; do
    app_num=$((${app} == "counter" ? 1 : ${app} == "calculator" ? 2 : 3))
    echo "Building and pushing app${app_num} (${app})..."
    
    # Dockerイメージのビルド
    docker build --build-arg APP_DIR=app${app_num} -t gradio-apps:${app} .
    
    # ECRにプッシュ
    docker tag gradio-apps:${app} ${ECR_REPOSITORY_URL}:${app}
    docker push ${ECR_REPOSITORY_URL}:${app}
done

# 環境変数の置換とKubernetesマニフェストの適用
envsubst < k8s-deployments.yaml | kubectl apply -f -

# デプロイメントの状態を確認
echo "Waiting for deployments to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/gradio-counter-app
kubectl wait --for=condition=available --timeout=300s deployment/gradio-calculator-app
kubectl wait --for=condition=available --timeout=300s deployment/gradio-text-app

# サービスのエンドポイントを表示
echo -e "\nApplication endpoints:"
kubectl get services | grep gradio
