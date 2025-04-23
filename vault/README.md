
# Vault Service Overview

This repo contains a Dockerized setup of HashiCorp Vault designed for local or internal infrastructure use. It features:

- **S3-compatible storage (MinIO)**
- **Auto-unseal via AWS KMS**
- **Optional TLS via Vault-issued certificates**
- **No regrets (well, fewer)**

---

## 📁 Repo Structure

| Folder        | Purpose                                      |
|---------------|----------------------------------------------|
| `install/`    | One-time setup scripts (Vault init, CA setup)|
| `config/`     | SSL certificate setup guides and PKI details |
| `policies/`   | Vault ACL policies                           |
| `.yaml`| Vault service and dependencies (Docker)      |


## Purpose

This setup provides a **locally hosted Vault instance** for secure secret management, configured to use:

- **S3 (MinIO)** as backend storage  
- **AWS KMS** for auto-unseal  
- TLS certificates (but optionally disabled for local testing)

---

## Key Features

- **UI Enabled**: Vault’s web UI is available at `http://vault.internal:8200`.
- **S3 Backend**: Secrets are stored in an object storage bucket (`vault`) managed by MinIO.
- **KMS Seal**: Automatically unseals Vault using AWS KMS (or a simulated KMS if mocked).
- **TLS Support**: SSL certificates are supported but disabled by default in this config.

---

## Environment Variables (`vault.env`)

This file is ignored in version control but must be created and sourced at runtime.  
These are passed into the Vault container and used to configure S3 and KMS access.

```env
# MinIO (S3 backend)
VAULT_S3_BUCKET=vault
VAULT_S3_ACCESS_KEY=data_root
VAULT_S3_SECRET_KEY=
VAULT_S3_ENDPOINT=http://minio.internal:9000

# AWS KMS (auto-unseal)
VAULT_KMS_REGION=
VAULT_KMS_KEY_ID=
VAULT_KMS_ACCESS_KEY=
VAULT_KMS_SECRET_KEY=
```

> 💡 **Note:** You must fill in the blank values or inject them at runtime. No one wants a Vault that can’t open.

---

## Configuration Summary

### Vault Core Settings

| Setting         | Value                              |
|-----------------|------------------------------------|
| `api_addr`      | `http://vault.internal:8200`       |
| `ui`            | `true`                             |
| `disable_mlock` | `true` (bad, but okay for local)   |

---

### S3 Storage (MinIO)

```hcl
storage "s3" {
  bucket              = "vault"  # From env
  access_key          = "PLACEHOLDER_ACCESS_KEY"
  secret_key          = "PLACEHOLDER_SECRET_KEY"
  endpoint            = "http://minio.internal:9000"
  scheme              = "https"
  s3_force_path_style = true
  disable_ssl         = true
}
```

> 📝 SSL is technically disabled, but the `scheme = "https"` stays because MinIO doesn’t care. Weird? Yes. It works? Also yes.

---

### Listener (TCP)

```hcl
listener "tcp" {
  address       = "[REDACTED_IP]:8200"
  tls_cert_file = "/etc/vault.d/public.crt"
  tls_key_file  = "/etc/vault.d/private.key"
  tls_disable   = 1
}
```

- TLS is disabled (`tls_disable = 1`) to keep dev setups simple.
- Do not expose this config to the public internet unless your favorite hobby is regret.

---

### Auto-Unseal with AWS KMS

```hcl
seal "awskms" {
  region     = "us-west-2"
  kms_key_id = "PLACEHOLDER_KMS_KEY_ID"
  access_key = "PLACEHOLDER_KMS_ACCESS_KEY"
  secret_key = "PLACEHOLDER_KMS_SECRET_KEY"
  disabled   = false
}
```

- All secrets above are expected to come from environment variables (`vault.env`)
- KMS must be reachable and properly configured.

---

### High Availability

```hcl
ha_enabled = true
```

You’re running solo now, but HA mode is enabled to make future scaling less of a headache.

---

## Launch Checklist

- ✅ `.env` and `vault.env` are defined and injected
- ✅ Certs exist and match hostnames (or TLS is off for dev)
- ✅ MinIO is running and the `vault` bucket exists
- ✅ KMS is reachable and has the key configured
- ✅ Vault has been initialized and unsealed at least once

---

## Start Vault

```bash
docker compose up -d
```

## Access Vault

Web UI: [http://vault.internal:8200](http://vault.internal:8200)

CLI:

```bash
export VAULT_ADDR=http://vault.internal:8200
vault status
```

---

## ⚠️ Security Warnings

- `disable_mlock = true`: Don't do this in production unless you love RAM leaks.
- `tls_disable = 1`: Only use for local dev in sealed boxes, preferably your basement.
- Avoid committing real values—use `vault.env`, `docker secrets`, or go touch grass.
- If Vault can't unseal, you’ll have to manually initialize/unseal it again. Don't panic.
