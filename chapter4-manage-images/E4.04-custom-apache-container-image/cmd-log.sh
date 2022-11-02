#!/bin/bash

# Log in to quay.io
podman login quay.io
# Start container from httpd image
podman run -d --name official-httpd -p 8180:80 quay.io/redhattraining/httpd-parent

# Start terminal session in container
podman exec -it official-httpd /bin/bash
# Create basic html page
echo "DO180 Page" > /var/www/html/do180.html
exit
# Ensure html file is reachable from host
# Often web server containers label /var/www/html as a volume. But since the image
# pulled earlier doesn't label it as a volume, the diff is present in the output.
curl 127.0.0.1:8180/do180.html

# Stop container
podman stop official-httpd
# Commit changes to new container image
podman commit -a 'Your Name' official-httpd do180-custom-httpd
# List images on host
podman images

# Run config cmd to load env vars
source /usr/local/etc/ocp4.config
# Tag image with registry host name and tag
podman tag do180-custom-httpd quay.io/${RHT_OCP4_QUAY_USER}/do180-custom-httpd:v1.0
# List images to ensure new name is added to cache
podman images
# Push image to Quay.io registry
podman push quay.io/${RHT_OCP4_QUAY_USER}/do180-custom-httpd:v1.0
# Verify image is available from Quay.io
podman pull -q quay.io/${RHT_OCP4_QUAY_USER}/do180-custom-httpd:v1.0

# Create container from custom image
podman run -d --name test-httpd -p 8280:80 ${RHT_OCP4_QUAY_USER}/do180-custom-httpd:v1.0
# Ensure page is reachable
curl http://localhost:8280/do180.html
