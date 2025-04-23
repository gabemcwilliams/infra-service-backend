# 🛠️ service-templates

This repository contains a curated set of infrastructure and service templates designed for local development, internal
cloud environments, and secure self-hosting scenarios.

It's structured to demonstrate practical knowledge in:

- **Secrets management with Vault**
- **PKI and TLS automation (with caution)**
- **Secure S3-compatible storage using MinIO**
- **Reverse proxy routing and TLS termination via Nginx**
- **Container orchestration with Docker Compose**
- **Environment isolation and layered configuration management**

> This is not a toy setup. These templates are based on real-world problems I've had to solve—and learned from the hard
> way.

---

## 🔐 Primary Services

| Folder      | Purpose                                                                              |
|-------------|--------------------------------------------------------------------------------------|
| `vault/`    | Vault setup with PKI CA, auto-unseal via AWS KMS, S3 backend, and TLS integration    |
| `config/`   | Manual cert configuration for Vault, MinIO, and Nginx with detailed SSL walkthroughs |
| `install/`  | One-time initialization scripts for Vault PKI setup                                  |
| `policies/` | Vault ACL policies used during setup or testing                                      |

---

## 🌐 Reverse Proxy Architecture

All services are exposed via a centralized Nginx instance that handles TLS termination, subdomain routing, and security
headers.  
See `nginx.conf` for detailed configuration of each service route.

Example external URLs:

- `https://vault.example.internal`
- `https://minio.example.internal`
- `https://grafana.example.internal`

---

## 🚀 Quick Start

> This setup assumes a local or internal network with trusted DNS (or hosts file entries) for `*.example.internal`.

```bash
# Start core services
cd vault
docker compose up -d
```

Ensure the following are configured:

- Environment variables in `.env` and `vault.env`
- Cert files placed in expected volume paths
- MinIO backend reachable
- Nginx configured and running on host

---

## 📄 About This Repo

This repo is designed more for **reference and demonstration** than turnkey deployment.  
Services are wired together manually to showcase:

- Service dependencies
- Secret flows
- Network layering
- TLS configuration without magic scripts

If you’re looking for `terraform apply && forget`, this is not that.

---

## 🧱 Future Plans

This stack is being expanded into a modular edge AI platform with:

- **LoRaWAN support via Chirpstack** for IoT telemetry ingestion
- **Prometheus + Grafana** for metrics and observability
- **Custom APIs and scrapers** to collect and enrich external datasets
- **Vault-managed PKI** to handle secure service-to-service authentication
- **A janky-but-functional UI layer** using Streamlit, Dash, or whatever else glues together fast
