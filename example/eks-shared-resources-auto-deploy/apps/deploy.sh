#!/bin/bash

# 色の定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# エラーが発生したら即座に終了
set -e

# 変数設定
APP_NUMBER=$1
APP_NAME=$2
ECR_REPOSITORY_URL=$(terraform -chdir=../terraform output -raw ecr_repository_url)
AWS_REGION="ap-northeast-1"
CLUSTER_NAME="eks-shared-cluster"

# 引数チェック
if [ -z "$APP_NUMBER" ] || [ -z "$APP_NAME" ]; then
    echo -e "${RED}使用方法: $0 <アプリ番号> <アプリ名>${NC}"
    echo -e "${YELLOW}例: $0 4 image${NC}"
    exit 1
fi

echo -e "${GREEN}🚀 新しいアプリケーションのデプロイを開始します...${NC}"

# 1. アプリケーションディレクトリの作成
echo -e "${BLUE}📁 アプリケーションディレクトリを作成中...${NC}"
mkdir -p "app${APP_NUMBER}"

# 2. AWS認証情報の確認
echo -e "${PURPLE}🔐 AWS認証情報を確認中...${NC}"
if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
    if [ -f "../.env" ]; then
        source "../.env"
    else
        echo -e "${RED}❌ AWS認証情報が設定されていません${NC}"
        exit 1
    fi
fi

# 3. kubectlの設定
echo -e "${CYAN}⚙️ kubectlの設定を更新中...${NC}"
aws eks update-kubeconfig --name $CLUSTER_NAME --region $AWS_REGION

# 4. ECRログイン
echo -e "${YELLOW}🔑 ECRにログイン中...${NC}"
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPOSITORY_URL

# 5. Dockerイメージのビルドとプッシュ
echo -e "${BLUE}🏗️ Dockerイメージをビルド中...${NC}"
docker build --build-arg APP_DIR="app${APP_NUMBER}" -t "gradio-apps:${APP_NAME}" .

echo -e "${PURPLE}📤 ECRにイメージをプッシュ中...${NC}"
docker tag "gradio-apps:${APP_NAME}" "${ECR_REPOSITORY_URL}:${APP_NAME}"
docker push "${ECR_REPOSITORY_URL}:${APP_NAME}"

# 6. Kubernetesマニフェストの適用
echo -e "${CYAN}📦 Kubernetesマニフェストを適用中...${NC}"
kubectl apply -f k8s-deployments.yaml

# 7. デプロイ状態の確認
echo -e "${YELLOW}👀 デプロイ状態を確認中...${NC}"
kubectl get deployments
echo "---"
echo -e "${BLUE}🌐 サービスのエンドポイントを確認中...${NC}"
kubectl get services

echo -e "${GREEN}✅ デプロイが完了しました！${NC}"
