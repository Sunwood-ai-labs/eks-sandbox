# 環境変数の確認
if (-not $env:ECR_REPOSITORY_URL) {
    Write-Error "Error: ECR_REPOSITORY_URL environment variable is not set"
    exit 1
}

# AWS ECRへのログイン
Write-Host "Logging in to AWS ECR..."
aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin $env:ECR_REPOSITORY_URL

# アプリケーションのビルドとプッシュ
$apps = @(
    @{name = "counter"; dir = "app1"},
    @{name = "calculator"; dir = "app2"},
    @{name = "text"; dir = "app3"}
)

foreach ($app in $apps) {
    Write-Host "Building and pushing $($app.name)..."
    
    # Dockerイメージのビルド
    docker build --build-arg APP_DIR=$($app.dir) -t "gradio-apps:$($app.name)" .
    
    # ECRにプッシュ
    docker tag "gradio-apps:$($app.name)" "$env:ECR_REPOSITORY_URL`:$($app.name)"
    docker push "$env:ECR_REPOSITORY_URL`:$($app.name)"
}

# k8s-deployments.yamlの内容を環境変数で置換
Write-Host "Applying Kubernetes manifests..."
$manifest = Get-Content -Path "k8s-deployments.yaml" -Raw
$manifest = $manifest -replace '\$\{ECR_REPOSITORY_URL\}', $env:ECR_REPOSITORY_URL
$manifest | kubectl apply -f -

# デプロイメントの状態を確認
Write-Host "Waiting for deployments to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/gradio-counter-app
kubectl wait --for=condition=available --timeout=300s deployment/gradio-calculator-app
kubectl wait --for=condition=available --timeout=300s deployment/gradio-text-app

# サービスのエンドポイントを表示
Write-Host "`nApplication endpoints:"
kubectl get services | Select-String "gradio"
