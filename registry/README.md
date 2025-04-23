# Docker Registry Service Overview

## Purpose

This local Docker Registry provides a secure, private image repository for development and testing. It allows for
building, tagging, pushing, and managing container images **without relying on external registries**—perfect for
isolated environments or internal CI/CD pipelines.

## Key Features

- **Private Image Hosting**: Store and retrieve container images locally.
- **HTTPS Support**: TLS encryption via custom certificates ensures secure access.
- **Persistent Storage**: Registry data is preserved across restarts via mounted volumes.
- **Delete-Enabled**: Supports image and tag deletion through the HTTP API (because sometimes you *do* want to nuke it).
- **Custom Configuration**: Uses a mounted `.yml` for easy tweaks and debugging.

## Configuration

The registry is defined via the Docker Compose service and `.yml`. Key settings include:

### Ports

| Port | Description            |
|------|------------------------|
| 5000 | Secure registry access |

### Volumes

| Path                        | Description                                    |
|-----------------------------|------------------------------------------------|
| `${STORAGE_DIR}`            | Image and blob storage                         |
| `${CERTS_DIR}`              | TLS certificates (`public.crt`, `private.key`) |
| `${CONFIGS_DIR}.yml` | Custom configuration for the registry          |

### Environment Variables

| Variable                                    | Description                                         |
|---------------------------------------------|-----------------------------------------------------|
| `REGISTRY_HTTP_ADDR`                        | Interface and port to bind (usually `[REDACTED_IP]:5000`) |
| `REGISTRY_HTTP_TLS_CERTIFICATE`             | Path to TLS certificate                             |
| `REGISTRY_HTTP_TLS_KEY`                     | Path to private TLS key                             |
| `REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY` | Where registry data is stored                       |
| `REGISTRY_STORAGE_DELETE_ENABLED`           | Enable blob deletion via HTTP API                   |

## Pushing and Pulling Images

```bash
# Tag a local image
docker tag myapp registry.example.internal:5000/myapp:latest

# Push it to your registry
docker push registry.example.internal:5000/myapp:latest

# Pull it back (because trust is good, but verification is better)
docker pull registry.example.internal:5000/myapp:latest
```

## Image Deletion & Garbage Collection

To enable deletion:

1. Ensure `REGISTRY_STORAGE_DELETE_ENABLED=true` is set.
2. Delete via the HTTP API or compatible tools.
3. Run garbage collection to reclaim space:

```bash
.yml
```

> ⚠️ Warning: Garbage collection is ruthless. Deleted means **gone**.

## Notes

- **TLS is required**: Clients must trust the registry’s CA certificate.
- **Hostname matters**: The cert **must match** the domain used in your push/pull commands.
- **Health checks**: Optional, but not enabled by default (some clients will fail gracefully).
