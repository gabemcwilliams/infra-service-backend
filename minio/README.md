# MinIO Configuration (Linux)

This document outlines the configuration used to deploy **MinIO** on a Linux system with secure access, SSL termination,
and integration with Nginx for internal development and storage services.

---

## 🔐 Root Credentials

Define the root user and password for administrative access:

```env
MINIO_ROOT_USER=data_root
MINIO_ROOT_PASSWORD=
```

> ⚠️ Ensure your password is strong and stored securely (e.g., Vault, `.env` file). Never commit credentials.

---

## 📜 Certificate Configuration

MinIO requires SSL/TLS certificates for secure communication:

```env
MINIO_CERT_FILE=/home/minio/.minio/certs/public.crt
MINIO_KEY_FILE=/home/minio/.minio/certs/private.key
```

**Expected structure:**

```
/home/minio/.minio/certs/
│
├── public.crt
├── private.key
└── CAs/
```

> Make sure these certs exist and have the correct permissions (`minio:minio`).

---

## 💾 Storage Volumes

Configure where MinIO stores object data:

```env
MINIO_VOLUMES="/mnt/db/minio"
```

Ensure the directory exists:

```bash
sudo chown -R minio:minio /mnt/db/minio
sudo chmod -R 750 /mnt/db/minio
```

---

## 🌐 Server URL and Ports

This deployment is **not exposed to the public internet**. Traffic is routed through **Nginx**.

```env
MINIO_SERVER_URL="https://minio.example.internal:9000"
MINIO_HTTP_PORT="80"
MINIO_HTTPS_PORT="443"
MINIO_BROWSER=on
```

---

## 🖥️ Console Access

Enable the MinIO web console on a dedicated port, proxied through Nginx at `/minio/`:

```env
MINIO_CONSOLE_ADDRESS=":9001"
```

---

## 🛠 Systemd Management Tips

- Restart the service:
  ```bash
  sudo systemctl restart minio
  ```

- Check its status:
  ```bash
  sudo systemctl status minio
  ```

- View logs:
  ```bash
  sudo journalctl -u minio --no-pager
  ```

- Check loaded environment:
  ```bash
  sudo systemctl show minio | grep MINIO_
  ```

---

## ✅ Final Notes

- This configuration is intended for **internal use only**, behind Nginx.
- SSL is terminated at Nginx for public traffic, MinIO runs on internal ports only.
- Console UI is proxied and not directly exposed.

---