## 🔐 Vault PKI Configuration (Multi-SAN Certificate Setup)

This guide outlines the setup of HashiCorp Vault as a root Certificate Authority (CA) using the built-in PKI secrets
engine. Certificates are issued with multi-SAN support and used across Vault, Nginx, and MinIO for TLS encryption.

### ⚙️ Step 1: Enable and Configure Vault PKI

Enable the `pki` secrets engine and configure its maximum TTL:

```sh
vault secrets enable pki
vault secrets tune -max-lease-ttl=87600h pki
```

### 🏛️ Step 2: Generate a Root Certificate Authority (CA)

Create a self-signed root certificate valid for 10 years:

```sh
vault write pki/root/generate/internal \
    common_name="example.internal" \
    ttl="87600h"
```

Set the issuing and CRL distribution URLs:

```sh
vault write pki/config/urls \
    issuing_certificates="http://vault.example.internal:8200/v1/pki/ca" \
    crl_distribution_points="http://vault.example.internal:8200/v1/pki/crl"
```

### 🛂 Step 3: Define Certificate Roles

Define certificate issuance roles to control SANs and TTLs.

#### 🔹 Internal Services Role

Supports multiple specific service domains:

```sh
vault write pki/roles/internal-services \
    allowed_domains="example.internal,vault.example.internal,minio.example.internal,db.example.internal,internal" \
    allow_subdomains=true \
    allow_wildcard_certificates=true \
    max_ttl="8760h"
```

#### 🔸 Wildcard Role

Used for apps that support wildcard certs:

```sh
vault write pki/roles/wildcard-internal \
    allowed_domains="example.internal" \
    allow_subdomains=true \
    allow_wildcard_certificates=true \
    max_ttl="8760h"
```

### 📜 Step 4: Issue a Multi-SAN TLS Certificate

Example certificate issuance with multiple Subject Alternative Names:

```sh
vault write pki/issue/internal-services \
    common_name="example.internal" \
    alt_names="vault.example.internal,minio.example.internal,db.example.internal,*.example.internal" \
    ttl="8760h"
```

> This certificate can be used across services that require SSL termination, simplifying trust configuration and
> reducing cert sprawl.

---

**Next:** Proceed to [Vault SSL and Configuration](#) for extraction, file placement, and integration into system
services.
