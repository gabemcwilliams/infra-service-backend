### Commands:

1. **Set Ownership and Permissions for Certificates (`/mnt/data/swarm/certs/loki`)**

```bash
# Set ownership for the certs directory and its contents to 10001:docker
sudo chown 10001:docker -R /mnt/data/swarm/certs/loki

# Set permissions for certificates (read-write for owner, read-only for group and others)
sudo chmod 644 /mnt/data/swarm/certs/loki/*.crt
sudo chmod 600 /mnt/data/swarm/certs/loki/*.key
```

2. **Set Ownership and Permissions for Storage Directory (`/mnt/data/swarm/storage/loki`)**

```bash
# Set ownership for the storage directory and its contents to 10001:docker
sudo chown 10001:docker -R /mnt/data/swarm/storage/loki

# Set permissions for storage files (owner can read-write, others can read)
sudo chmod 770 /mnt/data/swarm/storage/loki
```

3. **Set Ownership and Permissions for Config Directory (`/mnt/data/swarm/configs/loki`)**

```bash
# Set ownership for the config directory and its contents to 10001:docker
sudo chown 10001:docker -R /mnt/data/swarm/configs/loki

# Set permissions for config files (owner can read-write, others can read)
sudo chmod 644 /mnt/data/swarm/configs/loki/*.yaml
```

### Explanation:

- **`chown 10001:docker -R /path/to/directory`**: This command recursively sets ownership of the directory and all its
  files to the user `10001` and group `docker`.
- **`chmod 644`**: Sets read-write permissions for the owner and read-only permissions for the group and others for the
  certificates and config files.
- **`chmod 600`**: Sets read-write permissions for the owner and no permissions for others on private keys (since they
  need to be kept secure).
- **`chmod 770`**: Sets full permissions for the owner and group, and no permissions for others, for the storage
  directory.

### After running these commands:

- **Certificates** will be owned by `10001:docker`, with read and write permissions for the owner and read-only
  permissions for others (except the private key, which is more secure with only owner access).
- **Config files** will be owned by `10001:docker` with appropriate permissions (read-write for the owner, and read-only
  for others).
- **Storage files** will be securely set with full access for the owner and group, but no access for others.

Let me know if you need further adjustments or clarification!