#!/bin/bash

echo `date`
start=`date +%s`

# paths
export SCRIPT_PATH=/vagrant

# common scripts
source ${SCRIPT_PATH}/scripts/supporting/common.sh

# ucp
docker run --rm -t --name ucp \
-v /var/run/docker.sock:/var/run/docker.sock \
-v /vagrant/docker_subscription.lic:/docker_subscription.lic \
-v /etc/hosts:/etc/hosts \
docker/ucp install \
--debug \
--host-address ${DOCKER1_IP} \
--controller-port ${UCP_HTTPS_PORT} \
--admin-username ${UCP_USER} \
--admin-password ${UCP_PASSWORD}

# the secondary ucp hosts need to verify
# the fingerprint of the primary
#docker run --rm --name ucp \
#-v /var/run/docker.sock:/var/run/docker.sock \
#docker/ucp fingerprint | cut -d '=' -f 2 > fingerprint.log

# store the join token for cluster members (1.12)
docker swarm join-token -q worker > worker-token.log

# serve up the fingerprint and token
nohup python -m SimpleHTTPServer 8000 </dev/null >/dev/null 2>&1 &

# install dtr
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
echo
echo "Login before pushing images to DTR with:"
echo
echo "docker login -u admin -p dolphins -e foo@bar.com ${DTR_URL}"
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
