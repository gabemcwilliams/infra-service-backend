Here is the updated version of the instructions based on your requests:

---

# Setting Up PostgreSQL and Connecting to Grafana Backend

## Prerequisites

- **PostgreSQL** is already installed and configured for production.
- **Grafana** is running and accessible.
- **Sudo privileges** on the host for creating users and databases.

---

### **1. Switch to PostgreSQL User**

PostgreSQL creates a system user `postgres` during installation. Switch to this user to manage PostgreSQL.

```bash
sudo -i -u postgres
```

---

### **2. Create PostgreSQL User and Database for Grafana**

Create a new PostgreSQL user and database for Grafana.

1. **Create a User**:

```bash
createuser --pwprompt grafana_user
```

   - You will be prompted for a password for the user `grafana_user`.

2. **Create a Database**:

```bash
createdb --owner=grafana_user grafana
```

   - This creates a database named `grafana` with the user `grafana_user` as the owner.

3. **Grant Permissions**:

```bash
psql
GRANT ALL PRIVILEGES ON DATABASE grafana TO grafana_user;
\q
```

---

### **3. Connect Grafana to PostgreSQL**

1. **Login to Grafana**:
   - Open Grafana in your browser, usually on `http://localhost:3000`.
   - Use the default credentials: **admin/admin**.

2. **Add PostgreSQL as a Data Source**:
   - In Grafana, navigate to **Configuration > Data Sources**.
   - Click **Add data source**.
   - Select **PostgreSQL**.

3. **Configure the Connection**:
   - **Name**: Choose a name for the data source (e.g., `PostgresDB`).
   - **Host**: Enter the PostgreSQL server’s hostname or IP and port (`localhost:5432` if running locally).
   - **Database**: Enter `grafana` (the database created earlier).
   - **User**: Enter `grafana_user` (the user created earlier).
   - **Password**: Enter the password for `grafana_user`.

   - **SSL Mode**: Choose `disable` unless you have SSL enabled.

4. **Update `grafana.ini`**:
   - Add or update the following lines in your `grafana.ini` configuration file to enable PostgreSQL as a backend:

   ```ini
   [database]
   type = postgres
   host = localhost:5432
   name = grafana
   user = grafana_user
   password = <password>
   ```

   - Alternatively, you can set these values in the environment variables if you are using a containerized version of Grafana:

   ```bash
   GF_DATABASE_TYPE=postgres
   GF_DATABASE_HOST=localhost:5432
   GF_DATABASE_NAME=grafana
   GF_DATABASE_USER=grafana_user
   GF_DATABASE_PASSWORD=<password>
   ```

5. **Save & Test**:
   - Click **Save & Test** to check if the connection works.

---

### **6. Switch Backend Database in Grafana**

If you have changed the backend database, **restart the Grafana container** to apply the changes:

```bash
docker restart grafana
```

Grafana will now connect to the PostgreSQL backend (`grafana` database).