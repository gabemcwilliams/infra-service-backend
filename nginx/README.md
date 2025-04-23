# Nginx Service Overview

## Purpose

This configuration uses **Nginx** as a secure, high-performance reverse proxy and load balancer. It efficiently handles
web traffic while providing SSL termination, routing, and access control to internal services.

---

## Key Features

- **Reverse Proxy**: Forwards client requests to backend services without exposing internal network details.
- **SSL Termination**: Handles HTTPS connections and decrypts traffic at the edge using certificates in
  `/etc/nginx/certs/`.
- **Access Control**: Centralizes inbound access enforcement for all external traffic.
- **Load Balancing** *(optional)*: Can distribute traffic across multiple backend instances.
- **Performance Optimizations**: Efficient handling of concurrent connections with minimal system overhead.

---

## Security Measures

- **SSL/TLS Encryption**: All external communication is encrypted using trusted certificates.
- **Restricted Proxy Rules**: Only predefined services are exposed through the reverse proxy.
- **Centralized Entry Point**: Reduces the attack surface by isolating backend services behind Nginx.

---

## Proxied Services

This configuration securely exposes the following internal services:

- **MinIO** — Object storage with a web UI and API.
- **Vault** — Secure access to secret management.
- **Portainer** — Web UI for Docker container management.
- **Grafana** — Dashboard for performance metrics and observability.
- **PostgreSQL** *(optional)* — TCP proxy for encrypted database connections.
- **Redis / RedisInsight**, **Kafka / Kafka-UI**, **MLflow**, **PgAdmin**, and **Prefect.io**

---

## Proxied Services

This setup routes traffic securely to the following internal services:

| Service          | Description                                      | URL Endpoint                         |
|------------------|--------------------------------------------------|--------------------------------------|
| **MinIO**        | S3-compatible object storage with web console    | `https://minio.{{DOMAIN}}`           |
| **Vault**        | Secrets management and secure credential storage | `https://vault.{{DOMAIN}}`           |
| **PgAdmin**      | Web-based PostgreSQL admin interface             | `https://pgadmin.{{DOMAIN}}`         |
| **Portainer**    | UI for managing Docker containers and volumes    | `https://portainer.{{DOMAIN}}`       |
| **Grafana**      | Dashboards and visualization for observability   | `https://grafana.{{DOMAIN}}`         |
| **MLflow**       | Machine learning experiment tracking             | `https://mlflow.{{DOMAIN}}`          |
| **Redis**        | Redis instance with SSL proxy                    | `https://redis.{{DOMAIN}}`           |
| **RedisInsight** | GUI for managing and visualizing Redis data      | `https://redisinsight.{{DOMAIN}}`    |
| **Kafka**        | Kafka broker SSL endpoint                        | `https://kafka.{{DOMAIN}}`           |
| **Kafka UI**     | Kafka management UI                              | `https://kafka-ui.{{DOMAIN}}`        |
| **Prefect**      | Orchestration UI & API for workflow management   | `https://prefect.{{DOMAIN}}`         |
| **PostgreSQL**   | Optional TCP proxy for encrypted DB connections  | `{{DOMAIN}}:6432` → `localhost:5432` |

---

## Why Nginx?

- **Security First** — SSL termination and strict routing policies.
- **Resource Efficiency** — Lightweight, high-performance proxy engine.
- **Flexible Architecture** — Can route HTTP, HTTPS, and even TCP traffic.

---

## Notes

- All SSL certificates and keys should be mounted into `/etc/nginx/certs/`.
- Reverse proxying allows services to remain on isolated internal networks.
- Configuration is optimized for stability and security out of the box.
- This setup is ideal for local development, lab environments, or self-hosted dashboards.


```text
                     ┌────────────────────────────┐
                     │       External Clients      │
                     └────────────────────────────┘
                               │  HTTPS (443)
                               ▼
                        ┌───────────────┐
                        │    NGINX      │
                        │  Reverse Proxy│
                        └───────────────┘
                               │
   ┌─────────────┬─────────────┼──────────────────────┬─────────────┐
   ▼             ▼             ▼                      ▼             ▼
┌────────┐   ┌────────┐   ┌───────────┐          ┌──────────┐   ┌─────────┐
│ Vault  │   │ MinIO  │   │ PgAdmin   │          │ Portainer│   │ Chirp...│
│ .internal │ │ .internal │ │ .internal │          │ .internal│   │ .internal│
└────────┘   └────────┘   └───────────┘          └──────────┘   └─────────┘
     │           │              │                     │               │
     ▼           ▼              ▼                     ▼               ▼
vault.internal:8200   minio.internal:9000   pgadmin.internal:4100  chirpstack.internal:9382
        │              │                          │                │
        ▼              ▼                          ▼                ▼
  Vault Server    MinIO Console/API         PostgreSQL UI      LoRaWAN Dashboard

   ┌────────────┬──────────────┬────────────┬────────────┬────────────┐
   ▼            ▼              ▼            ▼            ▼
Grafana   Prometheus    MLflow     Kafka     RedisInsight
.internal  .internal    .internal  .internal .internal

→ Services running on various ports internally:
- Vault → 8200
- MinIO → 9000/9001
- PgAdmin → 4100
- Grafana → 3000
- Prometheus → 9030
- MLflow → 5001
- RedisInsight → 5540
- Kafka → 9092
- Kafka-UI → 8080
- Portainer → 9443
- Docker Registry → 5000

→ All proxied via Nginx using:
- Wildcard TLS cert for *.example.internal
- Dedicated subdomains per service
- Optional websocket upgrades and header manipulation


