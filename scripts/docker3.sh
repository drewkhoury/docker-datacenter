#!/bin/bash

echo `date`
start=`date +%s`

# paths
export SCRIPT_PATH=/home/vagrant/sync

# common scripts
source ${SCRIPT_PATH}/scripts/supporting/common-ucp.sh

# pre-download images
source ${SCRIPT_PATH}/scripts/supporting/download-images.sh

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

echo
echo
echo '=============================================================='
echo '=================== Docker Datacenter ========================'
echo
echo "Try the following in your favourite browser:"
echo
echo "Universal Control Plane (UCP)  :: https://docker3:${UCP_HTTPS_PORT}"
echo
echo '=================== Docker Datacenter ========================'
echo '=============================================================='
echo

echo `date`
end=`date +%s`

let deltatime=end-start
let hours=deltatime/3600
let minutes=(deltatime/60)%60
let seconds=deltatime%60
printf "Time spent: %d:%02d:%02d\n" $hours $minutes $seconds