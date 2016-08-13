#!/bin/bash

# discover the docker ips
# docker has an issue with trying to join
# via a hacked /etc/hosts entry
export DOCKER1_IP=`cat /etc/hosts | grep docker1 | cut -f1`
export DOCKER2_IP=`cat /etc/hosts | grep docker2 | cut -f1`
export DOCKER3_IP=`cat /etc/hosts | grep docker3 | cut -f1`

# ucp
docker run --rm -t --name ucp \
-e "UCP_ADMIN_USER=admin" -e "UCP_ADMIN_PASSWORD=orca" \
-v /var/run/docker.sock:/var/run/docker.sock \
-v /etc/hosts:/etc/hosts \
docker/ucp join \
--debug \
--url https://${DOCKER1_IP}:8443 \
--fingerprint `curl -s http://${DOCKER1_IP}:8000/fingerprint.log` \
--replica --host-address ${DOCKER3_IP} \
--controller-port 8443
