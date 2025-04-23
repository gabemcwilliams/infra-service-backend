### Grafana Labs Stack (Observability)

This directory contains a self-hosted observability stack built around
the [Grafana Labs ecosystem](https://grafana.com/), including metrics, logs, dashboards, and service-level monitoring.

All services are containerized with Docker Compose and configured to run in a private, certificate-secured environment
using internal `.internal` DNS and static IP mapping for easier inter-service resolution.

# Grafana Labs Stack

This repo contains Docker Compose configs for a full observability stack (Prometheus, Loki, Grafana, etc.)

## Services

- [Grafana](grafana/README.md)
- [Loki](loki/README.md)
- [Prometheus](prometheus/README.md)
- [Promtail](promtail/README.md)
- [Alloy](alloy/README.md)


---

### What's Included

| Service              | Description                                                |
|----------------------|------------------------------------------------------------|
| **Grafana**          | Dashboards and visualization layer.                        |
| **Prometheus**       | Metrics collection (pull-based).                           |
| **Loki**             | Centralized logging backend.                               |
| **Promtail**         | Log shipper for Loki.                                      |
| **Alloy**            | Lightweight agent that can replace Promtail/Node Exporter. |
| **MinIO (external)** | S3-compatible backend for Loki object storage.             |

---

### Security

- All services use **TLS certificates** from a shared `/etc/certs` volume.
- **Client authentication** is optionally enforced via mTLS.
- Internal-only services are never exposed outside Nginx.

---

### Folder Structure

```
grafana-labs/
├──.yml
├── grafana/
│   ├── grafana.ini
│   ├── provisioning/
│   └── README.md
├── loki/
│   ├──.yaml
│   └── README.md
├── promtail/
│   ├──.yaml
│   └── README.md
├── prometheus/
│   ├──.yaml
│   └── README.md
├── alloy/
│   ├── config.alloy
│   └── README.md
└── README.md
```

---

### Requirements

- Docker & Docker Compose
- TLS certs (public.crt, private.key, ca.crt)
- `.env` file defining:
    - `CONFIGS_DIR`
    - `STORAGE_DIR`
    - `CERTS_DIR`

---

### How to Run

```bash
docker compose up -d
```

All services will launch with TLS enabled, and are accessible via:

- `https://grafana.internal:3000`
- `https://prometheus.internal:9030`
- `https://loki.internal:3100`
- `https://redisinsight.internal:8001` *(if included)*
- etc.

---

### Why This Stack?

I use this setup for **end-to-end observability** in my home lab and personal projects:

- **Prometheus** scrapes metrics and feeds Grafana
- **Loki + Promtail** handles structured logs
- **Alloy** explores replacing multiple agents with one unified one
- **MinIO** is used as the object store for durability and S3 compatibility

This reflects my hands-on knowledge of metrics pipelines, log aggregation, and container monitoring across
microservices.

