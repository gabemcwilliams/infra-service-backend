# -----------------------------------------------------------------------------
# Ubuntu Firewall - UFW Configuration for Secure Containerized Server
# -----------------------------------------------------------------------------
#
#   Enables a secure firewall that allows:
#     - External access to web services via HTTPS and limited PostgreSQL proxy
#     - Internal-only access for object storage, database, and registry services
#     - Container network communication via Docker bridge interface
# -----------------------------------------------------------------------------

# Reset Existing Rules
ufw --force reset

# Default Policies
ufw default deny incoming
ufw default allow outgoing

# Allow Core Services
ufw allow 22/tcp comment 'SSH Access'
ufw allow 443/tcp comment 'HTTPS Web Services'

# External Access (Specific Workstations or Subnets)
ufw allow from [REDACTED_IP] to any port 9000 proto tcp comment 'MinIO API Access - Workstation'
ufw allow from [REDACTED_IP] to any port 9001 proto tcp comment 'MinIO Console Access - Workstation'
ufw allow from [REDACTED_IP] to any port 6432 proto tcp comment 'PostgreSQL Proxy Access - Workstation'
ufw allow from [REDACTED_IP] to any port 6432 proto tcp comment 'PostgreSQL Proxy Access - Secondary System'

# Internal Service Access (Docker Subnet)
ufw allow from [REDACTED_IP]/16 to any port 5432 proto tcp comment 'PostgreSQL - Docker Internal'
ufw allow from [REDACTED_IP]/16 to any port 8200 proto tcp comment 'Vault - Docker Internal'
ufw allow from [REDACTED_IP]/16 to any port 9000 proto tcp comment 'MinIO API - Docker Internal'
ufw allow from [REDACTED_IP]/16 to any port 9001 proto tcp comment 'MinIO Console - Docker Internal'
ufw allow from [REDACTED_IP]/16 to any port 5000 proto tcp comment 'Docker Registry - Docker Internal'

# Docker Network Bridging
ufw allow in on docker0 comment 'Container to Host - docker0'
ufw allow out on docker0 comment 'Host to Container - docker0'

# Enable Firewall
ufw --force enable

# Status Output
ufw status verbose
