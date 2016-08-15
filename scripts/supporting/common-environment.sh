#!/bin/bash

# vars
##############################################################
export SCRIPT_PATH=/home/vagrant/sync

# discover the docker ips
# docker has an issue with trying to join
# via a hacked /etc/hosts entry
export DOCKER1_IP=`cat /etc/hosts | grep docker1 | cut -f1`
export DOCKER2_IP=`cat /etc/hosts | grep docker2 | cut -f1`
export DOCKER3_IP=`cat /etc/hosts | grep docker3 | cut -f1`

# ucp
export UCP_HOST=${DOCKER1_IP}
export UCP_HTTPS_PORT=8443
export UCP_URL=${UCP_HOST}:${UCP_HTTPS_PORT}
export UCP_USER=admin
export UCP_PASSWORD=orca

# dtr
export DTR_HOST=$DOCKER1_IP
export DTR_PUBLIC_IP=${DOCKER1_IP}
export DTR_HTTP_PORT=1336
export DTR_HTTPS_PORT=1337
export DTR_URL=${DTR_HOST}:${DTR_HTTPS_PORT}

export UCP_VERSION=1.1.2
export DTR_VERSION=2.0.3