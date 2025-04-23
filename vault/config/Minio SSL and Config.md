## 📦 MinIO SSL Configuration (Vault-Issued Certificates)

This guide outlines the manual steps for configuring MinIO to use SSL certificates issued by HashiCorp Vault. Automation
is intentionally avoided to ensure controlled and traceable certificate deployment.

### 🔧 Step 1: Copy Vault-Issued Certificates to MinIO

MinIO expects its certificates in `/home/minio/.minio/certs/`.

```sh
sudo mkdir -p /home/minio/.minio/certs/CAs

# Main certificates
sudo cp /mnt/data/swarm/certs/vault/public.crt /home/minio/.minio/certs/public.crt
sudo cp /mnt/data/swarm/certs/vault/private.key /home/minio/.minio/certs/private.key

# CA certificate
sudo cp /mnt/data/swarm/certs/vault/ca.crt /home/minio/.minio/certs/CAs/ca.crt
```

### 🔒 Step 2: Set Ownership and Permissions

```sh
sudo chown -R minio:minio /home/minio/.minio/certs
sudo chmod 600 /home/minio/.minio/certs/private.key
sudo chmod 644 /home/minio/.minio/certs/public.crt /home/minio/.minio/certs/CAs/ca.crt
```

### 📝 Step 3: Update MinIO Environment Configuration

Edit `/etc/default/minio`:

```sh
MINIO_SERVER_URL=https://minio.example.internal:9000
MINIO_CERT_FILE=/home/minio/.minio/certs/public.crt
MINIO_KEY_FILE=/home/minio/.minio/certs/private.key
```

### 🔄 Step 4: Restart MinIO

```sh
sudo systemctl restart minio
sudo systemctl status minio
```

### ✅ Step 5: Verify HTTPS Connection

```sh
curl -v https://minio.example.internal:9000 \
  --cacert /home/minio/.minio/certs/CAs/ca.crt
```

If you see a valid HTTPS response, congratulations: MinIO is now securely using Vault-issued SSL certificates, and
you’ve resisted the urge to script this into a recursive certificate explosion.

---

> **Note:** Certificate validity, expiration, and renewal must be managed manually or with additional automation. This
> setup assumes a static deployment for demo or internal infrastructure purposes.

