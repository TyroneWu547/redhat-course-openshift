#!/bin/bash

# Start container named httpd-basic in detached mode with container port 8080 
# forwarding to 80 on host from quay.io/redhattraining/httpd-parent image
podman run -d -p 8080:80 --name httpd-basic quay.io/redhattraining/httpd-parent:2.4

# Test that Apache HTTP server is running inside the httpd-basic container
curl http://localhost:8080

# Customize the httpd-basic container to display 'Hello World' as the message
podman exec -it httpd-basic /bin/bash
# Overwrite content of index.html in container
echo "Hello World" > /var/www/html/index.html
# Exit container
exit
# Check that message is overwritten
curl http://localhost:8080
