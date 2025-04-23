

# PostgreSQL 17 Installation & Configuration (Ubuntu)

Comprehensive guide for setting up PostgreSQL 17 with SSL, custom directories, Nginx stream proxy, and basic automation. 🐘✨

---

## 1️⃣ Install PostgreSQL 17

```bash
# Add official PostgreSQL APT repo
echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" | \
  sudo tee /etc/apt/sources.list.d/pgdg.list

# Import signing key
wget -qO - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# Update & install
sudo apt update
sudo apt install -y postgresql-17 postgresql-client-17
```

---

## 2️⃣ Verify Installation

```bash
sudo systemctl status postgresql
psql --version
```

---

## 3️⃣ Configure PostgreSQL

### ✅ Move Data Directory

```bash
sudo systemctl stop postgresql

sudo mkdir -p /mnt/db/postgres/17/main
sudo chown -R postgres:postgres /mnt/db/postgres/17/main
sudo chmod 700 /mnt/db/postgres/17/main

sudo -u postgres /usr/lib/postgresql/17/bin/initdb -D /mnt/db/postgres/17/main
```

### 🛠 Update Configs

Edit `/etc/postgresql/17/main/postgresql.conf`:

```ini
data_directory = '/mnt/db/postgres/17/main'
listen_addresses = '[REDACTED_IP],[REDACTED_IP],[REDACTED_IP]'
port = 5432
max_connections = 100

ssl = on
ssl_ca_file = '/mnt/db/postgres/17/main/certs/ca.crt'
ssl_cert_file = '/mnt/db/postgres/17/main/certs/public.crt'
ssl_key_file = '/mnt/db/postgres/17/main/certs/private.key'

log_timezone = 'America/Phoenix'
```

Edit `/etc/postgresql/17/main/pg_hba.conf`:

```ini
host    all     all         [REDACTED_IP]/32            scram-sha-256
hostssl all     postgres    [REDACTED_IP]/32        cert clientcert=verify-full
hostssl all     postgres    [REDACTED_IP]/32        cert clientcert=verify-full
host    all     all         ::1/128                 scram-sha-256
```

---

## 4️⃣ Start PostgreSQL

```bash
sudo systemctl daemon-reexec
sudo systemctl enable postgresql
sudo systemctl restart postgresql
```

---

## 5️⃣ Create Superuser

```bash
sudo -u postgres psql

CREATE ROLE admin WITH SUPERUSER LOGIN PASSWORD 'strongpassword';
ALTER ROLE admin SET sslmode = 'require';

\q
```

---

## 6️⃣ Test Connectivity

```bash
# Local
psql "postgresql://admin@localhost:5432/postgres?sslmode=require"

# Remote
psql "postgresql://admin@db.example.internal:5432/postgres?sslmode=require"
```

---

## 7️⃣ Backup Configs

```bash
sudo cp /etc/postgresql/17/main/{postgresql.conf,pg_hba.conf} /mnt/data/builds/
sudo chown youruser:youruser /mnt/data/builds/*.conf
sudo chmod 644 /mnt/data/builds/*.conf
```

---

## 8️⃣ Enable Nginx Stream Proxy (Optional)

Edit `/etc/nginx/nginx.conf`:

```nginx
stream {
  server {
    listen 6432;
    proxy_pass [REDACTED_IP]:5432;
  }
}
```

Then restart:

```bash
sudo systemctl restart nginx
```

Connect using:

```bash
psql "postgresql://admin@db.example.internal:6432/postgres?sslmode=require"
```

---

## 9️⃣ Automate Backups (Optional)

```bash
sudo crontab -e
```

Add:

```cron
0 2 * * * pg_dumpall -U postgres | gzip > /mnt/db/backups/postgresql_$(date +\%Y\%m\%d).sql.gz
```

Backs up every night at 2AM.

---

## ✅ PostgreSQL Setup Complete

You're now running PostgreSQL 17 with:

- 🔐 SSL-based authentication  
- 🧩 Externalized config and data directories  
- 🧰 Superuser with remote access  
- 🔁 Optional Nginx stream proxy  
- 🛡️ Daily cron-based backups  

—

