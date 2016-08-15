#!/bin/bash

echo `date`
start=`date +%s`

# paths
export SCRIPT_PATH=/home/vagrant/sync

# common scripts
source ${SCRIPT_PATH}/scripts/supporting/common-ucp.sh

echo '=============================================================='
echo '=================== Install UCP =============================='
echo '=============================================================='


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

echo "sleeping 60s to allow UCP to catch up from installing"
sleep 60s

source ${SCRIPT_PATH}/scripts/supporting/dtr.sh

echo
echo
echo '=============================================================='
echo '=================== Docker Datacenter ========================'
echo
echo "Try the following in your favourite browser:"
echo
echo "Universal Control Plane (UCP)  :: https://docker1:${UCP_HTTPS_PORT}"
echo "Docker Trusted Registry (DTR)  :: https://docker1:${DTR_HTTPS_PORT}"
echo "NOTE: First time open of DTR web page will cause 'app linking' to UCP "
echo "      to sync user accounts etc"
echo 
echo "Login before pushing images to DTR with:"
echo
echo "NOTE: run within vagrant machine"
echo "vagrant ssh docker1"
echo "docker login -u admin -p orca -e foo@bar.com ${DTR_URL}"
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
