## 🌐 Nginx SSL Configuration (Vault-Issued Certificates)

This guide documents how to configure Nginx to use TLS certificates issued by HashiCorp Vault, enabling secure HTTPS
connections.

### 📥 Step 1: Copy Vault-Issued Certificates to Nginx

```sh
sudo cp /mnt/data/swarm/certs/vault/* /etc/nginx/certs/
```

Ensure the directory exists and is owned by the appropriate user (`nginx` or `www-data`, depending on your setup).

### 📝 Step 2: Configure Nginx for SSL

Edit the main Nginx configuration:

```sh
sudo nano /etc/nginx/nginx.conf
```

Update or add the following SSL directives:

```nginx
ssl_certificate /etc/nginx/certs/public.crt;
ssl_certificate_key /etc/nginx/certs/private.key;
ssl_trusted_certificate /etc/nginx/certs/ca.crt;
```

Ensure the SSL block is inside the appropriate `server` block that listens on port `443`.

### 🔄 Step 3: Restart Nginx

```sh
sudo systemctl restart nginx
sudo systemctl status nginx
```

### ✅ Step 4: Verify the SSL Configuration

```sh
curl -v https://vault.example.internal \
  --cacert /etc/nginx/certs/ca.crt
```

A valid TLS handshake and proper HTTP response confirm that Nginx is correctly using Vault-issued certificates.

---

> **Tip:** Automating cert renewals? Consider reloading Nginx via `systemctl reload` after pushing updated certs, or
> better yet—add a cron job *once you're emotionally ready to trust cron with your life*.

---

**Next:** Proceed to [MinIO SSL Configuration](#) to secure MinIO with Vault-issued certificates.

