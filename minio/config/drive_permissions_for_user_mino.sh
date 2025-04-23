# -----------------------------------------------------------------------------
# MinIO Storage & Certificate Directory Permissions
# -----------------------------------------------------------------------------
# This script ensures that MinIO has the correct ownership and permissions for
# both the storage data directory and the certificates directory.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Step 1: Set Ownership for MinIO Data Directory
# -----------------------------------------------------------------------------
# - The MinIO service must have ownership of the data directory.
# - This ensures MinIO can read, write, and execute within the storage path.
# -----------------------------------------------------------------------------

sudo chown -R minio:minio /mnt/data/object-storage/data
sudo chmod u+rxw /mnt/data/object-storage/data

# -----------------------------------------------------------------------------
# Step 2: Set Ownership for MinIO Certificate Directory
# -----------------------------------------------------------------------------
# - The `.certs` directory stores SSL/TLS certificates for MinIO.
# - MinIO requires ownership and correct read/write/execute permissions.
# -----------------------------------------------------------------------------

sudo chown -R minio:minio /mnt/data/object-storage/.certs
sudo chmod u+rxw /mnt/data/object-storage/.certs
