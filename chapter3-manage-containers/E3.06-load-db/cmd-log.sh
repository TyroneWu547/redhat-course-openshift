#!/bin/bash

podman login registry.redhat.io

# Run container with configurations.
podman run --name mysqldb-port \
-d -v /home/student/local/mysql:/var/lib/mysql/data -p 13306:3306 \
-e MYSQL_USER=user1 -e MYSQL_PASSWORD=mypa55 \
-e MYSQL_DATABASE=items -e MYSQL_ROOT_PASSWORD=r00tpa55 \
registry.redhat.io/rhel8/mysql-80:1
# Verify container is created and running.
podman ps --format="{{.ID}} {{.Names}} {{.Ports}}"

# Populate db with provided file.
mysql -uuser1 -h 127.0.0.1 -pmypa55 \
-P13306 items < /home/student/DO180/labs/manage-networking/db.sql

# Verify db has loaded data. Choose one of the three:

# Execute non-interactive command inside container.
podman exec -it mysqldb-port mysql -uroot items -e "SELECT * FROM Item"
# Run query using port forwarding from local host.
mysql -uuser1 -h 127.0.0.1 -pmypa55 -P13306 items -e "SELECT * FROM Item"
# Open interactive terminal session inside container.
podman exec -it mysqldb-port /bin/bash
mysql -uroot items -e "SELECT * FROM Item"
exit
