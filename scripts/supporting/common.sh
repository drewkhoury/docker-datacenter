#!/bin/bash

# vars
##############################################################

# discover the docker ips
# docker has an issue with trying to join
# via a hacked /etc/hosts entry
export DOCKER1_IP=`cat /etc/hosts | grep docker1 | cut -f1`
export DOCKER2_IP=`cat /etc/hosts | grep docker2 | cut -f1`
export DOCKER3_IP=`cat /etc/hosts | grep docker3 | cut -f1`

# ucp
export UCP_HOST=${DOCKER1_IP}
export UCP_HTTPS_PORT=7443
export UCP_URL=${UCP_HOST}:${UCP_HTTPS_PORT}
export UCP_USER=admin
export UCP_PASSWORD=dolphins

# dtr
export DTR_HOST=$DOCKER1_IP
export DTR_PUBLIC_IP=${DOCKER1_IP}
export DTR_HTTP_PORT=1336
export DTR_HTTPS_PORT=1337
export DTR_URL=${DTR_HOST}:${DTR_HTTPS_PORT}


# install
##############################################################

# extra bits
sudo yum install git wget -y

wget -q https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
chmod +x jq-linux64

# install docker engine
source ${SCRIPT_PATH}/scripts/supporting/docker-engine.sh


# docker images - load from local files to save download time
##############################################################

# install docker images from local files
echo 'docker images (before docker load of sync/images/*)...'
docker images

for i in sync/images/*
do
    if [ -f "$i" ]; then
        echo 'loading images found locally...' $i
        docker load < $i
    fi
done

echo 'docker images (after docker load of sync/images/*)...'
docker images
