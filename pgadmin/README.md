## pgAdmin 4 Service

**pgAdmin** is a web-based GUI for managing PostgreSQL databases. This service runs `pgAdmin 4` in a container for local
development access.

### 🔧 Configuration

| Variable                   | Description                    |
|----------------------------|--------------------------------|
| `PGADMIN_DEFAULT_EMAIL`    | Login email for pgAdmin web UI |
| `PGADMIN_DEFAULT_PASSWORD` | Login password                 |

- Accessible at [http://localhost:4100](http://localhost:4100)
- Default login: `admin@example.com` / `admin`

### 🗂 Volumes

- Stores pgAdmin session data and connection settings under `${STORAGE_DIR}/`

### 🔌 Network

- Joined to the `postgresql` Docker network
- Static IP: `[REDACTED_IP]`
- Useful for local reverse proxy (e.g., `pgadmin.internal` behind Nginx)

### 💡 Notes

- Don’t expose this to the internet unless you want your database stolen by a bored intern in Belarus.
- Change the default credentials before production.
- This is mainly here for convenience when testing SQL queries or inspecting schemas.

