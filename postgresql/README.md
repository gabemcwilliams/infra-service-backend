# PostgreSQL Service Overview

## Purpose
This PostgreSQL service is configured for secure, high-performance database management with SSL encryption, custom storage, controlled access, and optional proxy support via Nginx.

## Key Features
- **Data Security**: Enforced SSL/TLS encryption to protect data in transit.
- **Custom Storage Location**: Data resides at `/mnt/db/postgres/17/main` for better organization and persistence.
- **Controlled Access**: Only specified internal IPs are permitted to connect.
- **Performance Optimization**: Tuned PostgreSQL settings for resource efficiency.
- **Nginx Proxy Support**: Optionally routes traffic through an Nginx TCP proxy.

## Security Measures
- **SSL Encryption**: Connections require valid certificates stored in `/mnt/db/postgres/17/main/certs/`.
- **IP Restrictions**: Only trusted IPs like `[REDACTED_IP]` and `[REDACTED_IP]` may authenticate.
- **Client Cert Auth**: Certificate-based client authentication is enforced.

## Connection Settings
- **Listen Addresses**: `[REDACTED_IP]`, `[REDACTED_IP]`, and `[REDACTED_IP]`.
- **Default Port**: PostgreSQL listens on port `5432`.
- **SSL Mode**: `sslmode=require` is enforced for all client connections.

## Nginx PostgreSQL Proxy (Optional)
- **Proxy Port**: Nginx listens on `6432`, forwarding to PostgreSQL on `5432`.
- **Purpose**: Enables abstraction, load balancing, or cross-network access control.
- **Use Case**: Ideal for containerized networks or external-facing app servers.

## Backup & Maintenance
- **Config Backups**: Key PostgreSQL config files are backed up to `/mnt/data/build/`.
- **Logging**: Logs are available and monitored for activity and debugging.
- **Autostart & Recovery**: PostgreSQL is configured to auto-start on boot and can be restarted via systemd.

## Example Client Connection
To connect securely from a remote machine:
```bash
psql "postgresql://postgres@db.example.internal:6432/postgres?sslmode=require"
```

## Additional Notes
- **Direct Access Available**: Direct connections on port `5432` are supported if not using Nginx.
- **Performance Tweaks**: Current config is tuned conservatively; adjust for workload as needed.
- **SSL Enforcement**: Insecure connections are denied by default.

