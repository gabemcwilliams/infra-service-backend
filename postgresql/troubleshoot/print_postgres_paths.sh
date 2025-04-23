#!/bin/bash

# This script prints important paths for PostgreSQL

# 1. PostgreSQL Binary Path
echo "PostgreSQL Binaries:"
which postgres
echo ""

# 2. Data Directory Path (PostgreSQL's data storage location)
echo "PostgreSQL Data Directory:"
sudo -u postgres psql -c "SHOW data_directory;"
echo ""

# 3. Configuration Files
echo "PostgreSQL Configuration Files:"
echo " - postgresql.conf: $(sudo -u postgres psql -c "SHOW config_file;" | tail -n 3)"
echo " - pg_hba.conf: $(sudo -u postgres psql -c "SHOW hba_file;" | tail -n 3)"
echo " - pg_ident.conf: $(sudo -u postgres psql -c "SHOW ident_file;" | tail -n 3)"
echo ""

# 4. Log Directory (where PostgreSQL logs are stored)
echo "PostgreSQL Log Directory:"
sudo -u postgres psql -c "SHOW log_directory;"
echo ""

# 5. Temporary Files Directory
echo "PostgreSQL Temporary Files Directory:"
sudo -u postgres psql -c "SHOW temp_tablespaces;"
echo ""

# 6. WAL Directory (Write-Ahead Log files)
echo "PostgreSQL WAL Directory:"
sudo -u postgres psql -c "SHOW wal_level;"
echo " - WAL File Location: $(sudo -u postgres psql -c "SHOW data_directory;" | tail -n 3)/pg_wal"
echo ""

# 7. Service Path (for systemd if running PostgreSQL as a service)
echo "PostgreSQL Service Path:"
systemctl show postgresql | grep "ExecStart"
echo ""

# 8. PostgreSQL Installed Path (where PostgreSQL is installed)
echo "PostgreSQL Installed Path:"
dpkg-query -L postgresql | head -n 10  # Change to 'rpm -ql postgresql' for RedHat/CentOS
echo ""

echo "All paths printed above should give you key locations for PostgreSQL on your system."
