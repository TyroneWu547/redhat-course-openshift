#!/bin/bash

# Build and run container image
podman build --layers=false -t do180/custom-apache .
podman images

podman run -d -p 20080:8080 --name containerfile do180/custom-apache
podman ps

curl localhost:20080:8080
