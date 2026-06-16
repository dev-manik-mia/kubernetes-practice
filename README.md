# Kubernetes App (Minikube)

Full-stack app with Caddy, Frontend (React/nginx), Backend (Node), Redis, and PostgreSQL running on Minikube.

## Architecture

```
Browser
  └── Caddy :30080 (NodePort)
        ├── /api*  →  Backend :8080  →  PostgreSQL :5432
        │                             →  Redis :6379
        └── /*     →  Frontend :80
```

## Prerequisites

- [Minikube](https://minikube.sigs.k8s.io/docs/start/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- Docker

## Deploy

```bash
minikube start
./deploy.sh
```

The script will:
1. Point Docker to Minikube's daemon (so images are available inside the cluster)
2. Build `backend:latest` and `frontend:latest` locally
3. Apply all manifests in order
4. Wait for all deployments to be ready
5. Print the app URL

## Teardown

```bash
kubectl delete namespace app
```

## Useful commands

```bash
# Watch pods
kubectl get pods -n app -w

# View logs
kubectl logs -n app deployment/backend
kubectl logs -n app deployment/caddy

# Open app in browser
minikube service caddy -n app

# Access Minikube dashboard
minikube dashboard
```

## k8s/ structure

```
k8s/
├── namespace.yml
├── secrets.yml           # Postgres credentials
├── backend-configmap.yml # Non-sensitive env vars
├── postgres/
│   ├── pvc.yml
│   ├── deployment.yml
│   └── service.yml
├── redis/
│   ├── deployment.yml
│   └── service.yml
├── backend/
│   ├── deployment.yml
│   └── service.yml
├── frontend/
│   ├── deployment.yml
│   └── service.yml
└── caddy/
    ├── configmap.yml     # Caddyfile
    ├── deployment.yml
    └── service.yml
```
