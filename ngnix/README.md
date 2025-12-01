# setup https and reverse proxy nginx for AWX

## install nginx 
```shell
cd
sudo dnf update
sudo dnf install nginx -y
sudo nginx -v
sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl status nginx
# create a certifcat
sudo mkdir -p /etc/nginx/ssl
sudo openssl req -x509 -nodes -days 5 -newkey rsa:2048 \
  -keyout /etc/nginx/ssl/awx.kind.local.key \
  -out /etc/nginx/ssl/awx.kind.local.crt \
  -subj "/CN=awx.kind.local/O=AWX Testing"
cd /etc/nginx/conf.d/
sudo vi awx-host.conf
# copy and paste 
```
```yaml
# in awx-host.conf
# Redirect HTTP to HTTPS
server {
    listen 80;
    server_name awx.kind.local;
    return 301 https://$host$request_uri;
}

# HTTPS Reverse Proxy to the kubectl port-forward tunnel
server {
    listen 443 ssl;
    server_name awx.kind.local;

    # SSL certificate and key paths on your HOST machine
    ssl_certificate /etc/nginx/ssl/awx.kind.local.crt;
    ssl_certificate_key /etc/nginx/ssl/awx.kind.local.key;

    ssl_session_cache shared:SSL:1m;
    ssl_session_timeout 5m;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers "EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH";
    ssl_prefer_server_ciphers on;

    # IMPORTANT: This block prevents common NGINX 502/504 errors with proxied applications
    proxy_buffering off;
    proxy_request_buffering off;
    proxy_read_timeout 300s;
    proxy_send_timeout 300s;
    keepalive_timeout 60s;

    location / {
        # This is where NGINX proxies to the kubectl port-forward tunnel
        proxy_pass http://127.0.0.1:30600;

        # Essential headers for AWX to function correctly, especially for websockets and redirects
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https; # Tell AWX that the original request was HTTPS

        # Headers for WebSocket support (crucial for AWX console/job output)
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }

    # Optionally, add NGINX access and error logs for debugging
    access_log /var/log/nginx/awx.kind.local_access.log;
    error_log /var/log/nginx/awx.kind.local_error.log;
}
```
## Restart nginx
```shell
sudo nginx -t
sudo systemctl restart nginx
sudo systemctl status nginx
```

## Configure your hosts file
```shell
#Edit your /etc/hosts file (or C:\Windows\System32\drivers\etc\hosts on Windows):
172.15.0.29 awx.kind.local  # as an example
```

## Stop firewalld and SElinux
```shell
sudo systemctl stop firewalld
sudo setenforce 0
```

Go to CONTAINERS_POOL.md
