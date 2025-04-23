## 🔐 Vault SSL Configuration

This guide details how to manually extract and configure Vault’s TLS certificates using a previously issued multi-SAN
certificate. This step is critical for securing Vault’s API and UI with HTTPS.

---

### 📁 Step 1: Extract and Store Certificate Files

Start by creating a dedicated directory for Vault certificates:

```sh
mkdir -p /mnt/data/swarm/certs/vault
cd /mnt/data/swarm/certs/vault
```

Open your issued certificate bundle (e.g., `.txt`) and extract the relevant sections into separate files:

```sh
.txt
```

Copy each section into its own file:

- `ca_chain.crt` – Full certificate chain
- `ca.crt` – Root Certificate Authority
- `private.key` – Vault's private key
- `public.crt` – Vault's server certificate

Set appropriate file permissions:

```sh
sudo chmod 600 private.key
sudo chmod 644 public.crt ca.crt ca_chain.crt
```

---

### ⚙️ Step 2: Configure Vault to Use TLS

Edit Vault’s configuration:

```sh
sudo nano /etc/vault.d/vault.hcl
```

Update the `listener` block with your certificate paths:

```hcl
listener "tcp" {
  address            = "[REDACTED_IP]:8200"
  tls_cert_file      = "/mnt/data/swarm/certs/vault/public.crt"
  tls_key_file       = "/mnt/data/swarm/certs/vault/private.key"
  tls_client_ca_file = "/mnt/data/swarm/certs/vault/ca.crt"
}
```

Save and restart the Vault service:

```sh
sudo systemctl restart vault
```

---

✅ If the service restarts without errors and responds over `https://vault.example.internal:8200`, your SSL configuration
is complete.

> **Next:** Proceed to [Nginx SSL and Configuration](#) to apply Vault-issued certificates to Nginx.

