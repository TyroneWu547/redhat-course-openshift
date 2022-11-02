#!/bin/bash

# Pull and run container image nginx:1.17
podman pull quay.io/redhattraining/nginx:1.17
podman run --name official-nginx -d -p 8080:80 quay.io/redhattraining/nginx:1.17

# Open terminal session in container and edit page
podman exec -it official-nginx /bin/bash
echo 'DO180' > /usr/share/nginx/html/index.html
curl 127.0.0.1:8080

# Stop container and commit changes to new container image
podman stop official-nginx
podman commit -a 'Tyrone Wu' official-nginx do180/mynginx:v1.0-SNAPSHOT
podman images

# Start new container with recently created image
podman run --name official-nginx-dev -d -p 8080:80 do180/mynginx:v1.0-SNAPSHOT

# Open terminal session in container and edit page again
podman exec -it official-nginx-dev /bin/bash
echo 'DO180 Page' > /usr/share/nginx/html/index.html
exit
curl 127.0.0.1:8080

# Stop container and commit changes again to new container image
podman stop official-nginx-dev
podman commit -a 'Tyrone Wu' official-nginx-dev do180/mynginx:v1.0
podman images

# Remove do180/mynginx:v1.0-SNAPSHOT from local
podman ps -a --format="{{.Names}}"
podman rm official-nginx-dev
podman ps -a --format="{{.Names}}"
podman rmi do180/mynginx:v1.0-SNAPSHOT
podman images

# Create new container from do180/mynginx:v1.0
podman run -d --name my-nginx -p 8280:80 do180/mynginx:v1.0
curl localhost:8280
