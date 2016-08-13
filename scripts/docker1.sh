#!/bin/bash

SCRIPT_PATH=/home/vagrant/sync

# install docker engine, and pull the ucp image
source ${SCRIPT_PATH}/scripts/supporting/docker-engine.sh

docker load < ${SCRIPT_PATH}/offline/ucp-1.1.2_dtr-2.0.2.tar.gz

# ucp
docker run --rm -t --name ucp \
-v /var/run/docker.sock:/var/run/docker.sock \
-v /home/vagrant/sync/docker_subscription.lic:/docker_subscription.lic \
-v /etc/hosts:/etc/hosts \
docker/ucp install \
--debug \
--swarm-port 3376 \
--host-address ${DOCKER1_IP} \
--controller-port 8443

# the secondary ucp hosts need to verify 
# the fingerprint of the primary
docker run --rm --name ucp \
-v /var/run/docker.sock:/var/run/docker.sock \
docker/ucp fingerprint | cut -d '=' -f 2 > fingerprint.log

# serve up the fingerprint
nohup python -m SimpleHTTPServer 8000 </dev/null >/dev/null 2>&1 &  

# install dtr
# source ${SCRIPT_PATH}/scripts/supporting/dtr-v1.sh
source ${SCRIPT_PATH}/scripts/supporting/dtr.sh