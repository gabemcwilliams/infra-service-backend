# -----------------------------------------------------------------------------
# MinIO Certificate Generation & Setup
# -----------------------------------------------------------------------------
# This script downloads, installs, and configures MinIO CertGen for generating 
# SSL/TLS certificates. The certificates are moved to the MinIO service account 
# directory with correct ownership.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Step 1: Download & Install MinIO CertGen
# -----------------------------------------------------------------------------
# CertGen is a MinIO utility for generating self-signed certificates.
# - Ensure you have `wget` and `dpkg` installed before proceeding.
# -----------------------------------------------------------------------------

# Download the latest CertGen package for Linux
wget https://github.com/minio/certgen/releases/download/v1.2.0/certgen_1.2.0_linux_amd64.deb

# Install CertGen using Debian's package manager
sudo dpkg -i certgen_1.2.0_linux_amd64.deb

# -----------------------------------------------------------------------------
# Step 2: Generate TLS Certificates for MinIO
# -----------------------------------------------------------------------------
# Generate self-signed TLS certificates for MinIO using CertGen.
# - Replace <fqdn> with the fully qualified domain name of your MinIO server.
# - Replace <ip_address> with the server's IP address.
# -----------------------------------------------------------------------------

sudo certgen -host <fqdn>,<ip_address>

# -----------------------------------------------------------------------------
# Step 3: Create Home Folder for MinIO Service Account
# -----------------------------------------------------------------------------
# MinIO expects certificates to be stored in:
# `/home/minio-user/.minio/certs`
# -----------------------------------------------------------------------------

sudo mkdir -p /home/minio-user/.minio/certs

# -----------------------------------------------------------------------------
# Step 4: Move Certificates to MinIO Certs Directory
# -----------------------------------------------------------------------------
# - Moves the generated TLS certificates (`private.key` and `public.crt`) 
#   to the MinIO service account directory.
# -----------------------------------------------------------------------------

sudo mv private.key public.crt /home/minio-user/.minio/certs

# -----------------------------------------------------------------------------
# Step 5: Set Correct Ownership for MinIO
# -----------------------------------------------------------------------------
# - The MinIO process must have the correct file ownership.
# - Change ownership of the MinIO home directory recursively.
# -----------------------------------------------------------------------------

sudo chown -R minio:minio /home/minio-user
