#!/usr/bin/env bash
set -e

echo "==> Pointing Docker to Minikube's daemon..."
eval $(minikube docker-env)

echo "==> Building images inside Minikube..."
docker build -t backend:latest ./backend
docker build -t frontend:latest ./frontend

echo "==> Applying Kubernetes manifests..."
kubectl apply -f k8s/namespace.yml
kubectl apply -f k8s/secrets.yml
kubectl apply -f k8s/backend-configmap.yml
kubectl apply -f k8s/postgres/
kubectl apply -f k8s/redis/
kubectl apply -f k8s/backend/
kubectl apply -f k8s/frontend/
kubectl apply -f k8s/caddy/

echo "==> Waiting for pods to be ready..."
kubectl rollout status deployment/postgres  -n app
kubectl rollout status deployment/redis     -n app
kubectl rollout status deployment/backend   -n app
kubectl rollout status deployment/frontend  -n app
kubectl rollout status deployment/caddy     -n app

echo ""
echo "==> Opening app (Ctrl+C to stop tunnel)..."
minikube service caddy -n app
