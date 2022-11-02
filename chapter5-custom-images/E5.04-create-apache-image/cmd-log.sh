#!/bin/bash

# Create image from Containerfile
podman build --layers=false -t do180/apache .
podman images

# Create container from image
podman run --name lab-apache -d -p 10080:80 do180/apache
podman ps
curl localhost:10080
