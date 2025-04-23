# -----------------------------------------------------------------------------
# MinIO Installation - Single-Node Single-Drive (Standalone)
# -----------------------------------------------------------------------------
# This script installs MinIO in standalone mode for local development
# and evaluation purposes. It does NOT provide high availability.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# BEFORE RUNNING: Verify the Latest MinIO Version
# -----------------------------------------------------------------------------
# - Always check for the latest MinIO release before installation:
#   https://min.io/docs/minio/linux/operations/install-deploy-manage/upgrade-minio-deployment.html
# - Update the download URL to match the latest available version.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Step 1: Download the Latest MinIO Package
# -----------------------------------------------------------------------------
# - Fetches the latest MinIO `.deb` package from the official release page.
# - Saves the file as `minio.deb` for installation.
# - Ensure that the URL is up to date before running this script.
# -----------------------------------------------------------------------------

wget https://dl.min.io/server/minio/release/linux-amd64/archive/minio_20240803043323.0.0_amd64.deb -O minio.deb

# -----------------------------------------------------------------------------
# Step 2: Install MinIO Using dpkg
# -----------------------------------------------------------------------------
# - Installs the downloaded MinIO `.deb` package.
# - Requires `sudo` privileges.
# -----------------------------------------------------------------------------

sudo dpkg -i minio.deb

