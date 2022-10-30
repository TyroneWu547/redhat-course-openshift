#!/bin/bash

# Login to redhat container catalog with redhat account.
podman login registry.redhat.io

# Download the MySQL database image and attempt to start it.
# Should expect error message about env variables.
podman run --name mysql-db registry.redhat.io/rhel8/mysql-80:1
# If ran in detached mode, the error message are not displayed. 
# Output logs to display the error message.
podman logs mysql-db

# Run mysql container with env variables.
podman run --name mysql \
-d -e MYSQL_USER=user1 -e MYSQL_PASSWORD=mypa55 \
-e MYSQL_DATABASE=items -e MYSQL_ROOT_PASSWORD=r00tpa55 \
registry.redhat.io/rhel8/mysql-80:1

# Verify that container started correctly.
podman ps

# Run podman cp command to copy database file to mysql container.
podman cp /home/student/DO180/labs/manage-lifecycle/db.sql mysql:/
# Populate the items database with the Projects table.
podman exec mysql /bin/bash -c 'mysql -uuser1 -pmypa55 items < /db.sql'

# Create another container using same container image as the previous container.
# Start entry point with bash shell.
podman run --name mysql-2 -it registry.redhat.io/rhel8/mysql-80:1 /bin/bash
# Try connecting to mysql database. Should expect error bc entry point did not start
# mysql server.
mysql -uroot
# Exit container
exit

# Verify mysql-2 is not running. This is bc we did not run above container as 
# background process in -d mode.
podman ps

# Query mysql container
podman exec mysql /bin/bash \
-c 'mysql -uuser1 -pmypa55 -e "select * from items.Projects;"'