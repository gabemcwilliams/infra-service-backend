# 🔹 Prefect Build & Deploy Instructions:
#
# Build the image:
#   docker build --pull --no-cache --progress=plain -t registry.example.internal:5000/vault_ubuntu_22.04:latest -f /mnt/data/build/vault/Dockerfile /mnt/data/build/vault/
#
# Explanation:
#    -t registry.example.internal:5000/vault_ubuntu_22.04:latest → Tags the image with your private registry.
#    -f Dockerfile → Specifies the Dockerfile location.
#    . → The build context (files used during build).
#
# Push the image:
#   docker push registry.example.internal:5000/vault_ubuntu_22.04:latest

# ────────────────────────────────────────────────────────────────────────────

# Use official Ubuntu 24.04 image
FROM ubuntu:24.04

# ────────────────────────────────────────────────────────────────────────────

# Labels
LABEL maintainer="builds@example.com"
LABEL version="0.2"
LABEL description="Custom Docker Image for HashiCorp Vault with MinIO backend"

# ────────────────────────────────────────────────────────────────────────────

# Install dependencies (each step is split for better debugging)
RUN apt-get update

RUN apt-get install -y curl

RUN apt-get install -y net-tools

RUN apt-get install -y iputils-ping

RUN apt-get install -y systemd

RUN apt-get install -y gpg

RUN apt-get install -y wget

RUN apt-get install -y lsb-release

RUN apt-get install -y libcap2-bin

RUN apt-get install -y jq

RUN apt-get install -y nano

# ────────────────────────────────────────────────────────────────────────────

# Add HashiCorp Repo
RUN wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    | tee /etc/apt/sources.list.d/hashicorp.list

RUN apt-get update

# ────────────────────────────────────────────────────────────────────────────

# Install Vault
RUN apt-get install -y vault

# ────────────────────────────────────────────────────────────────────────────

# Fix first-time start issue
RUN apt-get install --reinstall -y vault

# ────────────────────────────────────────────────────────────────────────────

# Set Vault to run as a service
RUN systemctl enable vault.service

# ────────────────────────────────────────────────────────────────────────────

# Expose Vault UI, API, and MinIO Backend ports
EXPOSE 8200 9000
