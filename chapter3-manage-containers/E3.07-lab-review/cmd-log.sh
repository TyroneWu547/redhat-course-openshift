#!/bin/bash

podman login registry.redhat.io

####################################################################################
## Create the /home/student/local/mysql directory with the correct SELinux context 
## and permissions.
mkdir -pv /home/student/local/mysql

# Add container SELinux context to directory and its contents.
sudo semanage fcontext -a -t container_file_t '/home/student/local/mysql(/.*)?'
# Apply SELinux policy to directory.
sudo restorecon -R /home/student/local/mysql
# Change owner of directory to match mysql user and mysql group for container image.
podman unshare chown -Rv 27:27 /home/student/local/mysql

####################################################################################
## Deploy a MySQL container instance.
podman run --name mysql-1 -p 13306:3306 -d \
-v /home/student/local/mysql:/var/lib/mysql/data \
-e MYSQL_USER=user1 -e MYSQL_PASSWORD=mypa55 -e MYSQL_DATABASE=items \
-e MYSQL_ROOT_PASSWORD=r00tpa55 registry.redhat.io/rhel8/mysql-80:1
# Verify container is running.
podman ps --format="{{.ID}} {{.Names}}"

####################################################################################
## Populate database with provided data.
# Load db with mysql command.
mysql -uuser1 -h 127.0.0.1 -pmypa55 -P13306 \
items < /home/student/DO180/labs/manage-review/db.sql
# Query db table.
mysql -uuser1 -h 127.0.0.1 -pmypa55 -P13306 items -e "SELECT * FROM Item"

####################################################################################
## Stop container gracefully.
podman stop mysql-1

####################################################################################
## Create new container
podman run --name mysql-2 -p 13306:3306 -d \
-v /home/student/local/mysql:/var/lib/mysql/data \
-e MYSQL_USER=user1 -e MYSQL_PASSWORD=mypa55 -e MYSQL_DATABASE=items \
-e MYSQL_ROOT_PASSWORD=r00tpa55 registry.redhat.io/rhel8/mysql-80:1
# Verify container is running.
podman ps --format="{{.ID}} {{.Names}}"

####################################################################################
## Save all containers to file.
podman stop mysql-1

####################################################################################
## Open terminal session in container to verify db data.
podman exec -it mysql-2 /bin/bash
# Open mysql cmd prompt as root user.
mysql -uroot
# Display table.
use items;
SELECT * FROM Item;
# Exit to host
exit
exit

####################################################################################
## Insert row in db with port forwarding.
mysql -uuser1 -h 127.0.0.1 -pmypa55 -P13306 items
# Insert row
insert into Item (description, done) values ('Finished lab', 1);
exit

####################################################################################
## Remove stopped containers
podman ps -a --format="{{.Names}} {{.Status}}"
podman rm mysql-1
