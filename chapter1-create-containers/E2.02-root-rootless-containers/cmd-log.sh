#!/bin/bash

# Start container with sudo from the Red Hat UBI 8 image
sudo podman run --rm --name asroot -ti registry.access.redhat.com/ubi8:latest /bin/bash
# Start sleep process inside container
sleep 1000

# On a new terminal, run ps to search for the process
sudo ps -ef | grep "sleep 1000"

# Exit container
exit

# Start another container from the Red Hat UBI 8 as a regular user
podman run --rm --name asuser -ti registry.access.redhat.com/ubi8:latest /bin/bash
whoami
id
# Start sleep process inside container
sleep 2000

# On a new terminal, run ps to search for the process
sudo ps -ef | grep "sleep 2000" | grep -v grep

# Exit container
exit
