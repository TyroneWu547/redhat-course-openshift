#!/bin/bash

# Log into openshift cluster
oc login -u ${RHT_OCP4_DEV_USER} -p ${RHT_OCP4_DEV_PASSWORD} ${RHT_OCP4_MASTER_API}

# Create new project
oc new-project ${RHT_OCP4_DEV_USER}-mysql-openshift
# Create new application from mysql-persistent template
oc new-app --template=mysql-persistent \
-p MYSQL_USER=user1 -p MYSQL_PASSWORD=mypa55 -p MYSQL_DATABASE=testdb \
-p MYSQL_ROOT_PASSWORD=r00tpa55 -p VOLUME_CAPACITY=10Gi

# View status of the new app
oc status

# List pods
oc get pods
# View more details about the pod
oc describe pod mysql-1-5rvms

# List services
oc get svc
# View more details about the service
oc describe service mysql

# List persistent storage claims
oc get pvc
# View more details about the pvc
oc describe pvc mysql

# Connect to mysql database server
# Configure port forwarding between host and db pod from using port 3306. Terminal will hang...
oc port-forward mysql-1-5rvms 3306:3306
# From another terminal, open mysql cli
mysql -uuser1 -pmypa55 --protocol tcp -h localhost
show databases;
exit

# Interrupt port forwarding terminal process, and delete all resources within the project
oc delete project ${RHT_OCP4_DEV_USER}-mysql-openshift

