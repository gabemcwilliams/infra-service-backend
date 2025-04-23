# MLflow Dev to Prod Setup with PostgreSQL and MinIO

This guide covers how to set up MLflow in a self-hosted environment using:
- **Artifact Store**: MinIO (S3-compatible)
- **Tracking Backend**: PostgreSQL
- **Runtime Environments**: Local developer machines, Docker Compose, and remote production services
- **Security**: HTTPS with custom/root CA certificates

This is designed for infrastructure-savvy developers and MLOps engineers.

---

## 1. Developer Environment Configuration (Remote HTTPS MLflow)

### Prerequisites
- Python ≥ 3.8 installed
- `mlflow` package installed
- Access to an HTTPS MLflow server (e.g., `https://mlflow.example.com`)
- Access to the trusted CA certificate (e.g., `ca.example.com.pem`)

### Step 1: Set the Tracking URI
```bash
export MLFLOW_TRACKING_URI="https://mlflow.example.com"
```
Or in Python:
```python
import mlflow
mlflow.set_tracking_uri("https://mlflow.example.com")
```

### Step 2: Trust the TLS Certificate
```bash
export REQUESTS_CA_BUNDLE="/path/to/ca.example.com.pem"
```
Make it persistent in your shell profile.

### Step 3: Test the Connection
```python
import mlflow
mlflow.set_tracking_uri("https://mlflow.example.com")

with mlflow.start_run(run_name="test_run"):
    mlflow.log_param("dev_test_param", 123)
    mlflow.log_metric("dev_test_metric", 0.987)
```

### Optional: System-wide Trust (Ubuntu/macOS)
Ubuntu:
```bash
sudo cp ca.example.com.pem /usr/local/share/ca-certificates/ca.crt
sudo update-ca-certificates
```
macOS:
```bash
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ca.example.com.pem
```

---

## 2. PostgreSQL Backend Setup

### Prerequisites
- PostgreSQL installed
- Sudo/root access

### Step 1: Create User and Database
```bash
sudo -i -u postgres
createuser --pwprompt mlflow
createdb --owner=mlflow mlflow
psql -c "GRANT ALL PRIVILEGES ON DATABASE mlflow TO mlflow;"
```

### Step 2: Build Connection URI
```bash
postgresql://mlflow:<password>@<host>:5432/mlflow
```

If using SSL:
```bash
postgresql://mlflow:<password>@<host>:5432/mlflow?sslmode=require&sslrootcert=/path/to/ca.crt
```

---

## 3. Docker Compose Deployment (MLflow + PostgreSQL + MinIO)

```yaml
services:
  mlflow:
    image: mlflow_custom_image:latest
    restart: unless-stopped
    ports:
      - "5010:5000"
    volumes:
      - "${CERTS_DIR}/public.crt:/mlflow/public.crt:ro"
      - "${CERTS_DIR}/private.key:/mlflow/private.key:ro"
      - "${CERTS_DIR}/ca.crt:/mlflow/ca.crt:ro"
      - "${STORAGE_DIR}/mlflow:/mlflow/data"
    env_file:
      - .env
    command: ["mlflow", "server",
              "--host", "[REDACTED_IP]",
              "--port", "5000",
              "--serve-artifacts",
              "--backend-store-uri", "${MLFLOW_SERVER_BACKEND_STORE_URI}",
              "--default-artifact-root", "${MLFLOW_SERVER_DEFAULT_ARTIFACT_ROOT}"]
```

---

## 4. MinIO Access Policy Example
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:*"],
      "Resource": ["arn:aws:s3:::ml-artifacts", "arn:aws:s3:::ml-artifacts/*"]
    }
  ]
}
```

---

## 5. Environment Variable Reference

```
# Tracking configuration
MLFLOW_TRACKING_URI=https://mlflow.example.com
REQUESTS_CA_BUNDLE=/path/to/ca.pem

# MinIO (artifact store)
AWS_ACCESS_KEY_ID=your_minio_key
AWS_SECRET_ACCESS_KEY=your_minio_secret
MLFLOW_S3_ENDPOINT_URL=https://minio.example.com:9000
AWS_DEFAULT_REGION=us-west-2

# PostgreSQL (tracking backend)
MLFLOW_SERVER_BACKEND_STORE_URI=postgresql://mlflow:<password>@db.example.com:5432/mlflow?sslmode=require&sslrootcert=/mlflow/ca.crt

# Artifact path
MLFLOW_SERVER_DEFAULT_ARTIFACT_ROOT=s3://ml-artifacts
```

---

## 6. Jupyter Notebook Integration

```python
.pytorch
from model import CircleModel

with mlflow.start_run():
    mlflow.log_param("lr", 0.001)
.pytorch.log_model(model, "model")
```

Artifacts will be stored in:
```
s3://ml-artifacts/<experiment_id>/<run_id>/artifacts/model/
```

---

## 7. Debugging Tips
- `printenv` inside container or Jupyter to validate variables
- Ensure Docker port 5000 is free
- Use `netstat -tulnp | grep 5000` to check port conflicts
- Clear broken experiments in PostgreSQL manually if needed

---

## ✅ Recap Table

| Step                        | Action                                                   |
|----------------------------|-----------------------------------------------------------|
| Set Tracking URI           | `MLFLOW_TRACKING_URI=https://...`                         |
| Trust TLS Cert             | `REQUESTS_CA_BUNDLE=/path/to/ca.pem`                      |
| PostgreSQL Setup           | `createuser`, `createdb`, `GRANT`                         |
| Docker Compose Config      | Use environment variables and volumes                     |
| Artifact Policy in MinIO   | JSON policy granting full `s3:*` access to `ml-artifacts` |
| Jupyter Test               | Log model & param using `.pytorch`                 |

---

MLflow is now ready for production-grade tracking with secure HTTPS communication, PostgreSQL metadata backend, and MinIO artifact storage. This workflow supports both development and production scalability.

