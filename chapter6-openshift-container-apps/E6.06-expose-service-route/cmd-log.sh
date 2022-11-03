#!/bin/bash

oc login -u ${RHT_OCP4_DEV_USER} -p ${RHT_OCP4_DEV_PASSWORD} ${RHT_OCP4_MASTER_API}
oc new-project ${RHT_OCP4_DEV_USER}-route

# Create PHP app
oc new-app --docker-image=quay.io/redhattraining/php-hello-dockerfile --name php-helloworld
# Monitor status with list retrieval
oc get pods -w
# Monitor status with logs 
oc logs -f php-helloworld-85484585d6-prskh

# Get details of service
oc describe svc/php-helloworld

# Expose the service to create a route
oc expose svc/php-helloworld
oc describe route

# Access service from a host external to cluster
curl php-helloworld-${RHT_OCP4_DEV_USER}-route.${RHT_OCP4_WILDCARD_DOMAIN}

## Replace route with new route named xyz
# Delete current route
oc delete route/php-helloworld
# Create new route with the name
oc expose svc/php-helloworld --name=${RHT_OCP4_DEV_USER}-xyz
oc describe route
# Make HTTP request using FQDN on port 80
curl ${RHT_OCP4_DEV_USER}-xyz-${RHT_OCP4_DEV_USER}-route.${RHT_OCP4_WILDCARD_DOMAIN}
