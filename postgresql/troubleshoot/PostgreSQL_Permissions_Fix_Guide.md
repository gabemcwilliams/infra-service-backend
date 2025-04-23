
# PostgreSQL Permissions Fix Guide

Follow these steps to correct file permissions and restart PostgreSQL.

## **1. Apply Permissions and Ownership Recursively to PostgreSQL Folder**

First, apply the correct ownership and permissions to the entire PostgreSQL data directory:

```bash
sudo chown -R postgres:postgres /mnt/db/postgres/17/main
sudo chmod -R 700 /mnt/db/postgres/17/main
```

This ensures the PostgreSQL user owns all files and directories, and only the `postgres` user can access them.

## **2. Apply Correct Permissions to Specific Files**

Ensure that the following critical files have the correct permissions:

### `pg_hba.conf`:
```bash
sudo chown postgres:postgres /etc/postgresql/17/main/pg_hba.conf
sudo chmod 600 /etc/postgresql/17/main/pg_hba.conf
```

### SSL Private Key (`private.key`):
```bash
sudo chmod 0600 /mnt/db/postgres/17/main/certs/private.key
```

These commands set the proper ownership and file permissions for the configuration files and private key.

## **3. Restart PostgreSQL Service**

After applying the permissions, restart the PostgreSQL service to apply the changes:

```bash
sudo systemctl restart postgresql@17-main.service
```
