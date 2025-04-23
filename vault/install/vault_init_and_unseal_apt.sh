
# -----------------------------------------------------------------------------
# HashiCorp Vault Installation & Setup (Recommended)
# -----------------------------------------------------------------------------
# This guide walks through installing, configuring, initializing, and unsealing
# HashiCorp Vault using `apt-get` on Ubuntu 22.04. It also ensures Vault is
# properly configured for a Docker-based or standalone deployment.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Step 1: Install Vault Using apt-get
# -----------------------------------------------------------------------------
# - This method uses HashiCorp’s official APT repository.
# - It allows better control over Vault versions and avoids Snap restrictions.
# -----------------------------------------------------------------------------

# Install required dependencies
sudo apt-get update && sudo apt-get install -y gpg curl software-properties-common

# Add HashiCorp’s official GPG key
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

# Add HashiCorp’s official repository
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

# Update repository and install Vault
sudo apt-get update && sudo apt-get install -y vault

# Verify Vault installation
vault --version

# -----------------------------------------------------------------------------
# Step 2: Configure Vault Environment Variables
# -----------------------------------------------------------------------------
# - If using a **bridge network**, add the Docker server’s IP.
# - Edit `/etc/environment` and define Vault’s address, namespace, and token.
# -----------------------------------------------------------------------------

# Open the file for editing
sudo nano /etc/environment

# -----------------------------------------------------------------------------
# Add the following lines at the end of the file (Update <redacted> values):
# -----------------------------------------------------------------------------
# VAULT_ADDR - Replace <fqdn> with the fully qualified domain name.
# The port may differ based on `.yaml` mapping or `vault.hcl` config.
# -----------------------------------------------------------------------------
VAULT_ADDR=https://<fqdn>:<port_of_https_listener>
VAULT_NAMESPACE=dc1

# -----------------------------------------------------------------------------
# WARNING: NEVER PUT THE ROOT TOKEN AS AN ENV VARIABLE
# - Wait until an admin policy is created before storing tokens.
# -----------------------------------------------------------------------------
VAULT_TOKEN=<redacted>

# -----------------------------------------------------------------------------
# Save the file and exit the text editor.
# Restart the system for changes to take effect.
# -----------------------------------------------------------------------------
sudo reboot

# -----------------------------------------------------------------------------
# Step 3: Enable & Start the Vault Service
# -----------------------------------------------------------------------------
# - Ensures that Vault runs as a system service.
# - The default config file location is `/etc/vault.d/vault.hcl`.
# -----------------------------------------------------------------------------

# Enable Vault systemd service
sudo systemctl enable vault

# Start Vault
sudo systemctl start vault

# Check Vault status
sudo systemctl status vault

# -----------------------------------------------------------------------------
# Step 4: Initialize Vault
# -----------------------------------------------------------------------------
# - Vault must be initialized before use.
# - This step generates unseal keys and an initial root token.
# - Store these keys and tokens **securely** (e.g., encrypted storage).
# -----------------------------------------------------------------------------

vault operator init

# -----------------------------------------------------------------------------
# Step 5: Unseal the Vault
# -----------------------------------------------------------------------------
# - Vault starts in a **sealed state** and must be unsealed before use.
# - Requires multiple unseal keys generated during initialization.
# -----------------------------------------------------------------------------

vault operator unseal

# -----------------------------------------------------------------------------
# Step 6: Enter Unseal Keys
# -----------------------------------------------------------------------------
# - Enter **three of the unseal keys** from the initialization process.
# - Once the required number of keys is entered, Vault is unsealed.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Step 7: Configure Vault to Auto-Unseal (Optional)
# -----------------------------------------------------------------------------
# - If using a cloud provider (AWS, GCP, Azure), configure auto-unsealing.
# - Modify `/etc/vault.d/vault.hcl` to include auto-unseal settings.
# -----------------------------------------------------------------------------

sudo nano /etc/vault.d/vault.hcl

# Example configuration for AWS KMS auto-unseal:
# seal "awskms" {
#   region     = "us-east-1"
#   kms_key_id = "<your-aws-kms-key-id>"
# }

# -----------------------------------------------------------------------------
# Step 8: Restart Vault After Configuration Changes
# -----------------------------------------------------------------------------

sudo systemctl restart vault

# -----------------------------------------------------------------------------
# Step 9: Verify Vault is Running
# -----------------------------------------------------------------------------

vault status
