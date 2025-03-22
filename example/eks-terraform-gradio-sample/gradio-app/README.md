# Simple Gradio Application for EKS

This is a simple Gradio web application that can be deployed to Amazon EKS (Elastic Kubernetes Service).

## Application Overview

The application is a simple sketch-to-image converter that demonstrates Gradio's capabilities. Users can draw sketches and see them displayed as images.

## Local Development

### Prerequisites

- Python 3.9+
- pip

### Setup

1. Install dependencies:
   ```
   pip install -r requirements.txt
   ```

2. Run the application locally:
   ```
   python app.py
   ```

3. Open your browser and navigate to `http://localhost:7860`

## Deployment to EKS

### Prerequisites

- Docker
- AWS CLI configured
- kubectl configured to work with your EKS cluster
- An ECR repository named 'gradio-app'

### Deployment Steps

1. Build the Docker image:
   ```
   docker build -t gradio-app .
   ```

2. Tag and push the image to ECR:
   ```
   aws ecr get-login-password --region <your-region> | docker login --username AWS --password-stdin <your-account-id>.dkr.ecr.<your-region>.amazonaws.com
   docker tag gradio-app:latest <your-account-id>.dkr.ecr.<your-region>.amazonaws.com/gradio-app:latest
   docker push <your-account-id>.dkr.ecr.<your-region>.amazonaws.com/gradio-app:latest
   ```

3. Update the image reference in `k8s-deployment.yaml` with your AWS account ID and region.

4. Deploy to Kubernetes:
   ```
   kubectl apply -f k8s-deployment.yaml
   ```

5. Get the external IP/URL of the service:
   ```
   kubectl get service gradio-app-service
   ```

6. Access your application using the EXTERNAL-IP provided by the service.

## Cleaning Up

To remove the deployment from your EKS cluster:
```
kubectl delete -f k8s-deployment.yaml
```
