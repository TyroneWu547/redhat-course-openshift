#!/bin/bash

mkdir -pv /home/student/local/mysql

# Add the appropriate SELinux context for the /home/student/local/mysql directory 
# and its contents.
sudo semanage fcontext -a -t container_file_t '/home/student/local/mysql(/.*)?'

# Apply the SELinux policy to the newly created directory.
sudo restorecon -R /home/student/local/mysql

# Verify that the SELinux context type for the /home/student/local/mysql directory 
# is container_file_t.
ls -ldZ /home/student/local/mysql

# Change the owner of the /home/student/local/mysql directory to the mysql user 
# and mysql group.
# Permissions is defined with numeric user ID (UID) from the container. 
# MySQL provided by redhat has UID 27
# podman unshare provides session to execute commands with user namespace with UID.
podman unshare chown 27:27 /home/student/local/mysql

# Pull MySQL redhat image.
podman login registry.redhat.io
podman pull registry.redhat.io/rhel8/mysql-80:1

# Run container from image and mounts /home/student/local/mysql from host 
# to /var/lib/mysql/data on container.
podman run --name persist-db \
-d -v /home/student/local/mysql:/var/lib/mysql/data \
-e MYSQL_USER=user1 -e MYSQL_PASSWORD=mypa55 \
-e MYSQL_DATABASE=items -e MYSQL_ROOT_PASSWORD=r00tpa55 \
registry.redhat.io/rhel8/mysql-80:1
# Verify that the container started correctly.
podman ps --format="{{.ID}} {{.Names}} {{.Status}}"

# Verify mounted dir has items dir.
ls -ld /home/student/local/mysql/items
# Alternatively run same cmd with podman unshare to check UID.
podman unshare ls -ld /home/student/local/mysql/items
