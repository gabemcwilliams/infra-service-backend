# -----------------------------------------------------------------------------
# Vault Operator Unseal - Migration Mode
# -----------------------------------------------------------------------------
# This command is used to **unseal Vault** and migrate data if needed.
# - Vault must be unsealed using multiple key shards before it becomes operational.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Step 1: Run the Vault Unseal Command
# -----------------------------------------------------------------------------
# - The `-migrate` flag is used if migrating data between storage backends.
# - Replace `<VAULT_ADDR>` with the actual Vault server address.
# -----------------------------------------------------------------------------

vault operator unseal -migrate -address <VAULT_ADDR>

# -----------------------------------------------------------------------------
# Step 2: Enter Unseal Keys
# -----------------------------------------------------------------------------
# - You need to **enter multiple key shards** (from Vault initialization).
# - Repeat the command as many times as needed to **reach the threshold**.
# -----------------------------------------------------------------------------
