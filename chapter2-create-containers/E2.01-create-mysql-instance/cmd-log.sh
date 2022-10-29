#!/bin/bash

# Login to redhat container catalog with redhat account
podman login registry.redhat.io

# Start container named mysql-basic (--name) from
# redhat container catalog MySQL image (registry.redhat.io/rhel8/mysql-80:1)
# with environment variables (-e) in detached mode (-d)
podman run --name mysql-basic \
-e MYSQL_USER=user1 -e MYSQL_PASSWORD=mypa55 \
-e MYSQL_DATABASE=items -e MYSQL_ROOT_PASSWORD=r00tpa55 \
-d registry.redhat.io/rhel8/mysql-80:1

# Verify that the container started without errors
podman ps --format "{{.ID}} {{.Image}} {{.Names}}"

# Access the container sandbox and start bash shell
podman exec -it mysql-basic /bin/bash

# Connect to mysql as admin user root
mysql -uroot