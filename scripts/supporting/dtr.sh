#!/bin/bash

SCRIPT_PATH=/home/vagrant/sync

# DTR - Offline content
#wget https://packages.docker.com/dtr/1.4/dtr-1.4.3.tar
#docker load < dtr-1.4.3.tar

# discover the docker ips
# docker has an issue with trying to join
# via a hacked /etc/hosts entry
export DOCKER1_IP=`cat /etc/hosts | grep docker1 | cut -f1`
export DOCKER2_IP=`cat /etc/hosts | grep docker2 | cut -f1`
export DOCKER3_IP=`cat /etc/hosts | grep docker3 | cut -f1`

UCP_HOST=${DOCKER1_IP}:8443
UCP_URL=$UCP_HOST
USER=admin
PASSWORD=orca
curl -k https://$UCP_HOST/ca > ucp-ca.pem

DTR_PUBLIC_IP=${DOCKER1_IP}
DTR_HTTP_PORT=1336
DTR_HTTPS_PORT=1337

docker run --rm \
    docker/dtr install \
    --ucp-url $UCP_URL \
    --ucp-ca "$(cat ucp-ca.pem)" \
    --ucp-username $USER --ucp-password $PASSWORD \
    --dtr-external-url $DTR_PUBLIC_IP:${DTR_HTTPS_PORT} \
    --replica-http-port ${DTR_HTTP_PORT} \
    --replica-https-port ${DTR_HTTPS_PORT} #\
    #--dtr-external-url     dtr.local
sleep 20

# some inspiration taken from:
# https://blog.docker.com/2016/04/docker-datacenter-ddc-in-a-box/

# reconfigure dtr to work with a specific domain
#source ${SCRIPT_PATH}/scripts/supporting/dtr-domain.sh

# general config
#source ${SCRIPT_PATH}/scripts/supporting/dtr-config.sh

# push image
#source ${SCRIPT_PATH}/scripts/supporting/dtr-push-image.sh
