# MLflow Service Overview

## Purpose
MLflow tracks and manages machine learning experiments, models, and metadata. This setup uses:
- **PostgreSQL** as the backend store
- **MinIO (S3-compatible)** for artifact storage
- **Nginx** for SSL termination and proxy routing

## Key Features
- **Experiment Tracking** with param/metric logging
- **Artifact Storage** via S3-compatible MinIO buckets
- **PostgreSQL Backend** for robust tracking storage
- **Secure Endpoints** via HTTPS and client-side certs (optional)

## Environment Variables
```bash
MLFLOW_SERVER_BACKEND_STORE_URI=postgresql://mlflow_user:***@db.internal:5432/mlflow?sslmode=require
MLFLOW_SERVER_DEFAULT_ARTIFACT_ROOT=s3://mlflow
S3_ENDPOINT_URL=https://minio.internal:9000
AWS_ACCESS_KEY_ID=...
AWS_SECRET_ACCESS_KEY=...
