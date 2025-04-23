# -----------------------------------------------------------------------------
# MinIO System User, Directories, and Permissions Setup
# -----------------------------------------------------------------------------
# This script sets up the MinIO system user, storage directories,
# and permissions required for MinIO to function securely.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Step 1: Create MinIO System Group
# -----------------------------------------------------------------------------
# - The MinIO service runs under a dedicated system group.
# - The `-r` flag ensures it's a system group.
# -----------------------------------------------------------------------------

sudo groupadd -r minio

# -----------------------------------------------------------------------------
# Step 2: Create MinIO System User
# -----------------------------------------------------------------------------
# - The `minio` user is created as a system user without a home directory.
# - The `-g minio` flag assigns it to the MinIO group created earlier.
# -----------------------------------------------------------------------------

sudo useradd -r -g minio minio

# -----------------------------------------------------------------------------
# Step 3: Create MinIO Storage Directory (If Not Already Created)
# -----------------------------------------------------------------------------
# - MinIO requires a dedicated storage directory.
# - Only create if the directory does not exist.
# -----------------------------------------------------------------------------

if [ ! -d "/mnt/data/object-storage" ]; then
    sudo mkdir /mnt/data/object-storage
fi

# -----------------------------------------------------------------------------
# Step 4: Set Permissions on Storage Directories
# -----------------------------------------------------------------------------
# - Ensures MinIO has full ownership and appropriate access to required paths.
# - The `/mnt/data/object-storage/` directory must be properly remapped.
# -----------------------------------------------------------------------------

sudo chown -R minio:minio /mnt/data/object-storage && sudo chmod u+rxw /mnt/data/object-storage
sudo chown -R minio:minio /mnt/data/object-storage/data && sudo chmod u+rxw /mnt/data/object-storage/data
sudo chown -R minio:minio /mnt/data/object-storage/.certs && sudo chmod u+rxw /mnt/data/object-storage/.certs

# -----------------------------------------------------------------------------
# Step 5: Configure MinIO Environment Variables
# -----------------------------------------------------------------------------
# - Opens MinIO's environment configuration file for editing.
# - Update this file with the correct MinIO settings.
# -----------------------------------------------------------------------------

sudo nano /etc/default/minio

# -----------------------------------------------------------------------------
# Step 6: Set Correct Permissions for MinIO Configuration
# -----------------------------------------------------------------------------
# - Ensures that MinIO has the correct ownership and permissions for its config.
# -----------------------------------------------------------------------------

sudo chown -R minio:minio /etc/default/minio && sudo chmod u+rxw /etc/default/minio

# -----------------------------------------------------------------------------
# Step 7: Create Home Directory for MinIO User (If Needed)
# -----------------------------------------------------------------------------
# - If the `-M` flag was used earlier, the home directory must be manually created.
# -----------------------------------------------------------------------------

# Uncomment if MinIO's home directory needs to be created manually
# sudo mkdir /home/minio

sudo mkdir -p /home/minio/.minio
sudo chown -R minio:minio /home/minio && sudo chmod u+rxw /home/minio

# -----------------------------------------------------------------------------
# Step 8: MinIO Certificate Storage Structure (For TLS)
# -----------------------------------------------------------------------------
# - MinIO requires SSL/TLS certificates to be stored in a specific directory.
# - Ensure that `private.key` and `public.crt` are correctly placed.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Linux: Certificates must be in `/home/<service_account>/.minio/certs`
# -----------------------------------------------------------------------------
# /home/<service_account>/.minio/
# └───certs
#     └───CAs
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Windows: Certificates must be in `%%USERPROFILE%%\.minio\certs\`
# -----------------------------------------------------------------------------
# D:\USERS\MINIO <%userprofile%>\<service_account_user>\
# └───.minio
#     └───certs
#         └───CAs
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Step 9: Set Ownership for MinIO Certificate Directory
# -----------------------------------------------------------------------------
# - Ensures MinIO has the correct access to its certificate directory.
# -----------------------------------------------------------------------------

sudo chown -R minio:minio /home/minio/.minio && sudo chmod u+rxw /home/minio/.minio
