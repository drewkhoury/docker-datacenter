#!/bin/bash

SCRIPT_PATH=/home/vagrant/sync

# install docker engine, and pull the ucp image
source ${SCRIPT_PATH}/scripts/supporting/docker-engine.sh

# ucp
docker run --rm -t --name ucp \
-e "UCP_ADMIN_USER=admin" -e "UCP_ADMIN_PASSWORD=orca" \
-v /var/run/docker.sock:/var/run/docker.sock \
-v /etc/hosts:/etc/hosts \
docker/ucp join \
--url https://${DOCKER1_IP}:8443 \
--fingerprint `curl -s http://${DOCKER1_IP}:8000/fingerprint.log` \
--replica --host-address ${DOCKER3_IP} \
--controller-port 8443
