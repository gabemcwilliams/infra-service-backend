# -----------------------------------------------------------------------------
# NGINX PID FILE FIX DOCUMENTATION
# -----------------------------------------------------------------------------
# This section outlines how to resolve issues with the missing or inaccessible
# nginx.pid file and ensures the correct permissions are set for Nginx to run
# properly.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# STEP 1: CREATE THE /RUN/NGINX DIRECTORY IF IT DOESN'T EXIST
# -----------------------------------------------------------------------------
# Nginx may fail to create its PID file if the /run/nginx directory is missing.
# Ensure that this directory exists.
#
# Run the following command to create the directory:
sudo mkdir -p /run/nginx

# -----------------------------------------------------------------------------
# STEP 2: SET THE CORRECT OWNERSHIP AND PERMISSIONS FOR /RUN/NGINX
# -----------------------------------------------------------------------------
# Ensure that the /run/nginx directory has the correct ownership and permissions.
# The directory must be owned by root with appropriate read/write/execute
# permissions for the necessary users.
#
# Run the following commands to set the ownership and permissions:
sudo chown root:root /run/nginx
sudo chmod 755 /run/nginx

# -----------------------------------------------------------------------------
# STEP 3: REMOVE ANY STALE NGINX.PID FILES
# -----------------------------------------------------------------------------
# If an old or stale nginx.pid file exists, it may block Nginx from starting
# properly. We need to remove any old PID files.
#
# Run the following command to remove any existing nginx.pid files:
sudo rm -f /run/nginx.pid

# -----------------------------------------------------------------------------
# STEP 4: CREATE THE NGINX.PID FILE IF NEEDED
# -----------------------------------------------------------------------------
# In case the nginx.pid file does not exist, we can manually create it. This is
# important to ensure that Nginx can track its process ID.
#
# Run the following commands to create the file:
sudo touch /run/nginx.pid

# -----------------------------------------------------------------------------
# STEP 5: SET CORRECT OWNERSHIP AND PERMISSIONS FOR NGINX.PID
# -----------------------------------------------------------------------------
# After creating the nginx.pid file, we need to set the appropriate ownership
# and permissions so that the Nginx process can read and write to it.
#
# The file should be owned by the root user and assigned to a group that allows
# Nginx's worker processes (e.g., 'nogroup' or 'www-data') to access it.
#
# Run the following commands to set the correct ownership and permissions:
sudo chown root:nogroup /run/nginx.pid  # 'nogroup' is used for unprivileged users
sudo chmod 644 /run/nginx.pid          # Set read/write for the owner, read-only for others

# -----------------------------------------------------------------------------
# STEP 6: TEST THE NGINX CONFIGURATION
# -----------------------------------------------------------------------------
# After making these changes, we need to test the Nginx configuration to ensure
# there are no syntax errors that would prevent Nginx from starting.
#
# Run the following command to test the configuration:
sudo nginx -t

# -----------------------------------------------------------------------------
# STEP 7: RESTART NGINX TO APPLY CHANGES
# -----------------------------------------------------------------------------
# Once the configuration test passes, we can restart Nginx to apply the changes
# and ensure Nginx is running with the correct permissions and the new PID file.
#
# Run the following command to restart Nginx:
sudo systemctl restart nginx

# -----------------------------------------------------------------------------
# STEP 8: VERIFY THAT THE NGINX.PID FILE EXISTS AND IS ACCESSIBLE
# -----------------------------------------------------------------------------
# Finally, verify that the nginx.pid file exists and Nginx can access it properly.
# If the file has been successfully created and the permissions are correct,
# it should be visible in the /run directory.
#
# Run the following commands to verify:
ls -la /run/nginx.pid

# -----------------------------------------------------------------------------
# INSTRUCTIONS FOR REGULAR MAINTENANCE
# -----------------------------------------------------------------------------
# If you ever need to fix the Nginx PID file again, repeat these steps as needed.
# Ensure that permissions are always set correctly to avoid startup issues.
#
# You can also automate the creation and permission fix by creating a custom script
# or adding these steps to a monitoring system to handle issues automatically.

# End of script documentation
