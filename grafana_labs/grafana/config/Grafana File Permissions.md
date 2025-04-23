### Commands:

1. **Set Ownership and Permissions for Grafana's Certificates (`/mnt/data/swarm/certs/grafana`)**

```bash
# Set ownership for the certs directory and its contents to 472:docker
sudo chown 472:docker -R /mnt/data/swarm/certs/grafana

# Set permissions for certificates (read-write for owner, read-only for group and others)
sudo chmod 644 /mnt/data/swarm/certs/grafana/*.crt
sudo chmod 600 /mnt/data/swarm/certs/grafana/*.key
```

2. **Set Ownership and Permissions for Grafana's Storage Directory (`/mnt/data/swarm/storage/grafana`)**

```bash
# Set ownership for the storage directory and its contents to 472:docker
sudo chown 472:docker -R /mnt/data/swarm/storage/grafana

# Set permissions for storage files (owner can read-write, others can read)
sudo chmod 770 /mnt/data/swarm/storage/grafana
```

3. **Set Ownership and Permissions for Grafana's Config Directory (`/mnt/data/swarm/configs/grafana`)**

```bash
# Set ownership for the config directory and its contents to 472:docker
sudo chown 472:docker -R /mnt/data/swarm/configs/grafana

# Set permissions for config files (owner can read-write, others can read)
sudo chmod 644 /mnt/data/swarm/configs/grafana/*.ini
```

### Explanation:

- **`chown 472:docker -R /path/to/directory`**: This command recursively sets the ownership of the directory and all its
  files to the user `472` (Grafana's user) and group `docker`.
- **`chmod 644`**: Sets read-write permissions for the owner and read-only permissions for the group and others for the
  certificates and config files.
- **`chmod 600`**: Sets read-write permissions for the owner and no permissions for others on private keys (which need
  to be secured).
- **`chmod 770`**: Sets full permissions for the owner and group, and no permissions for others on the storage
  directory.

### After running these commands:

- **Certificates** will be owned by `472:docker`, with read-write permissions for the owner and read-only permissions
  for others (except for private keys, which are restricted to the owner).
- **Config files** will be owned by `472:docker`, with appropriate permissions for Grafana's configuration (`read-write`
  for the owner and `read-only` for others).
- **Storage files** will be securely set with full access for the owner and group, but no access for others.

Let me know if you need any further details or adjustments!