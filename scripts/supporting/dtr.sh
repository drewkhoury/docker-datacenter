#!/bin/bash

SCRIPT_PATH=/home/vagrant/sync

# DTR - Offline content
#wget https://packages.docker.com/dtr/1.4/dtr-1.4.3.tar
#docker load < dtr-1.4.3.tar

# DTR
sudo bash -c "$(sudo docker run docker/trusted-registry install)"
sleep 20

# reconfigure dtr to work with a specific domain
source ${SCRIPT_PATH}/scripts/supporting/dtr-domain.sh

# general config
source ${SCRIPT_PATH}/scripts/supporting/dtr-domain.sh

# push image
source ${SCRIPT_PATH}/scripts/supporting/dtr-push-image.sh
