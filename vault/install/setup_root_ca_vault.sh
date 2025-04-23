# -----------------------------------------------------------------------------
# Vault PKI Setup - Multi-SAN Certificate Approach
# -----------------------------------------------------------------------------
# This setup enables Vault’s PKI, issues TLS certificates, and integrates them
# into Vault, MinIO, and Nginx for secure communications.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Step 1: Enable & Configure Vault PKI
# -----------------------------------------------------------------------------
# This step enables the PKI secrets engine and sets a long TTL for certificates.
# -----------------------------------------------------------------------------

# Enable the PKI secrets engine
vault secrets enable pki

# Set maximum certificate lease duration (10 years)
vault secrets tune -max-lease-ttl=87600h pki

# -----------------------------------------------------------------------------
# Generate Root CA
# -----------------------------------------------------------------------------
# Creates a self-signed Root CA valid for 10 years.
# -----------------------------------------------------------------------------
vault write pki/root/generate/internal common_name="example.internal" ttl="87600h"

# -----------------------------------------------------------------------------
# Configure Certificate Authority (CA) URLs
# -----------------------------------------------------------------------------
# Sets URLs for issuing certificates and retrieving Certificate Revocation Lists (CRLs).
# -----------------------------------------------------------------------------
vault write pki/config/urls issuing_certificates="http://vault.example.internal:8200/v1/pki/ca" crl_distribution_points="http://vault.example.internal:8200/v1/pki/crl"

# -----------------------------------------------------------------------------
# Step 2: Define Certificate Issuance Roles
# -----------------------------------------------------------------------------
# These roles allow flexible issuance of Multi-SAN and Wildcard certificates.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Multi-SAN Role (for Core Services)
# -----------------------------------------------------------------------------
# Allows issuing certificates with multiple subject alternative names (SANs).
# -----------------------------------------------------------------------------
vault write pki/roles/internal-services allowed_domains="example.internal,vault.example.internal,minio.example.internal,db.example.internal,internal" allow_subdomains=true allow_wildcard_certificates=true max_ttl="8760h"

# -----------------------------------------------------------------------------
# Wildcard Role (for Applications Supporting Wildcards)
# -----------------------------------------------------------------------------
# Enables wildcard certificates for all subdomains under example.internal.
# -----------------------------------------------------------------------------
vault write pki/roles/wildcard-internal allowed_domains="example.internal" allow_subdomains=true allow_wildcard_certificates=true max_ttl="8760h"

# -----------------------------------------------------------------------------
# Step 3: Issue Multi-SAN Certificates
# -----------------------------------------------------------------------------
# This step issues a TLS certificate with multiple SANs and saves it for further use.
# -----------------------------------------------------------------------------

# Issue a Multi-SAN certificate for Vault, MinIO, and DB services
vault write pki/issue/internal-services common_name="example.internal" alt_names="vault.example.internal,minio.example.internal,db.example.internal,*.example.internal" ttl="8760h"

# -----------------------------------------------------------------------------
# Store and Secure Certificates
# -----------------------------------------------------------------------------
# - Manually copy each certificate part from `.txt` into separate files.
# - Ensure correct permissions for security.
# -----------------------------------------------------------------------------

# Create the Vault certificate directory if it doesn't exist
mkdir -p /mnt/data/swarm/certs
cd /mnt/data/swarm/certs

# Open the cert file for manual extraction
.txt

# Extract and copy the relevant sections:
nano ca_chain.crt    # Copy the CA chain
nano ca.crt          # Copy only the Root CA
nano private.key     # Copy the Private Key
nano public.crt      # Copy the Server Certificate

# -----------------------------------------------------------------------------
# Secure Certificate Permissions
# -----------------------------------------------------------------------------
# - Private key: Only readable by the owner
# - Public certs: Readable by all services
# -----------------------------------------------------------------------------
sudo chmod 600 private.key
sudo chmod 644 public.crt ca.crt ca_chain.crt

# -----------------------------------------------------------------------------
# Step 4: Configure Vault, MinIO, and Nginx to Use TLS
# -----------------------------------------------------------------------------
# This step configures each service to use the issued TLS certificates.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Configure Vault for TLS
# -----------------------------------------------------------------------------
# Updates Vault's configuration file to use the issued certificates.
# -----------------------------------------------------------------------------
echo 'listener "tcp" {
  address = "[REDACTED_IP]:8200"
  tls_cert_file = "/mnt/data/swarm/certs/vault/public.crt"
  tls_key_file = "/mnt/data/swarm/certs/vault/private.key"
  tls_client_ca_file = "/mnt/data/swarm/certs/vault/ca_chain.crt"
}' | sudo tee /mnt/data/swarm/config/vault.hcl

# Restart Vault to apply the changes
sudo systemctl restart vault

# -----------------------------------------------------------------------------
# Configure MinIO for TLS
# -----------------------------------------------------------------------------
# Updates MinIO to use the issued TLS certificates for secure connections.
# -----------------------------------------------------------------------------
echo 'MINIO_SERVER_URL=https://minio.example.internal:9000
MINIO_CERT_FILE=/mnt/data/swarm/certs/vault/public.crt
MINIO_KEY_FILE=/mnt/data/swarm/certs/vault/private.key'

# Restart MinIO to apply the changes
sudo systemctl restart minio

# -----------------------------------------------------------------------------
# Configure Nginx for TLS
# -----------------------------------------------------------------------------
# Updates Nginx to use the issued TLS certificates for secure connections.
# -----------------------------------------------------------------------------
echo 'ssl_certificate /mnt/data/swarm/certs/vault/public.crt;
ssl_certificate_key /mnt/data/swarm/certs/vault/private.key;
ssl_trusted_certificate /mnt/data/swarm/certs/vault/ca_chain.crt;'

# Restart Nginx to apply the changes
sudo systemctl restart nginx

# -----------------------------------------------------------------------------
# Step 5: Test SSL & Vault Connectivity
# -----------------------------------------------------------------------------
# This step ensures all services are using the correct TLS certificates.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Verify Certificate Domains
# -----------------------------------------------------------------------------
# Tests if Vault and MinIO correctly serve the issued certificate.
# -----------------------------------------------------------------------------
openssl s_client -connect vault.example.internal:8200 -CAfile /mnt/data/swarm/certs/vault/ca_chain.crt
openssl s_client -connect minio.example.internal:9000 -CAfile /mnt/data/swarm/certs/vault/ca_chain.crt

# -----------------------------------------------------------------------------
# Validate Vault TLS Configuration
# -----------------------------------------------------------------------------
# Sets the VAULT_ADDR variable and attempts a login to confirm HTTPS is working.
# -----------------------------------------------------------------------------
export VAULT_ADDR="https://vault.example.internal:8200"
vault login

# -----------------------------------------------------------------------------
# Step 6: Automate Certificate Renewal & Service Reload
# -----------------------------------------------------------------------------
# This ensures that services always use the latest certificates.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Automate Certificate Updates via Cron
# -----------------------------------------------------------------------------
# - Every Monday at midnight, copy new certificates and restart services.
# - This ensures smooth certificate rotation without manual intervention.
# -----------------------------------------------------------------------------
echo "0 0 * * 1 root cp /mnt/data/swarm/certs/vault/* /etc/nginx/certs/ && systemctl restart nginx minio vault"
