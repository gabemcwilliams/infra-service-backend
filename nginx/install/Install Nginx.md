### Step 1: Update Your System
Before installing Nginx, it's always a good idea to update your system to ensure you have the latest package lists.

```bash
sudo apt update
sudo apt upgrade -y
```

### Step 2: Install Nginx
Now, install Nginx from the official Ubuntu repositories:

```bash
sudo apt install nginx -y
```

### Step 3: Start Nginx and Enable It to Start on Boot
After installation, you need to start the Nginx service and enable it to start on boot:

```bash
sudo systemctl start nginx
sudo systemctl enable nginx
```

### Step 4: Allow HTTP and HTTPS Through the Firewall (if applicable)
If you're using **UFW** (Uncomplicated Firewall), you need to allow HTTP and HTTPS traffic. Run:

```bash
sudo ufw allow 'Nginx Full'
```

If you're using another firewall or have it disabled, you can skip this step.

### Step 5: Verify Nginx is Running
To verify that Nginx is running, open your web browser and visit your server's IP address. You should see the Nginx default welcome page.

You can also check the service status from the command line:

```bash
sudo systemctl status nginx
```

### Step 6: Adjust Nginx Configuration (Optional)
By default, Nginx uses the default configuration file at `/etc/nginx/nginx.conf`. You can adjust this file for things like reverse proxying, load balancing, or SSL configurations.

You can edit the main configuration file with:

```bash
sudo nano /etc/nginx/nginx.conf
```

If you’re setting up server blocks (virtual hosts), you can create separate config files under `/etc/nginx/sites-available/` and link them to `/etc/nginx/sites-enabled/`.

### Step 7: Restart Nginx to Apply Changes
After making any changes to the configuration, restart Nginx to apply the changes:

```bash
sudo systemctl restart nginx
```

### Step 8: Check Nginx Configuration (Optional)
Before restarting Nginx, it's a good idea to check that there are no syntax errors in your Nginx configuration:

```bash
sudo nginx -t
```

If everything looks good, you should see a message saying `syntax is okay` and `test is successful`.


### Done!
Now you have Nginx installed and running on your Ubuntu server. If you’ve made any changes to your Nginx configuration or added SSL, don’t forget to restart the service using `sudo systemctl restart nginx`.

