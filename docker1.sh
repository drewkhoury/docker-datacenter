#!/bin/bash

# install docker engine, and pull the ucp image
source /home/vagrant/sync/docker-engine.sh

# ucp
sudo docker run --rm -t --name ucp \
-v /var/run/docker.sock:/var/run/docker.sock \
-v /home/vagrant/sync/docker_subscription.lic:/docker_subscription.lic \
-v /etc/hosts:/etc/hosts \
docker/ucp install \
--swarm-port 3376 \
--host-address ${DOCKER1_IP} \
--controller-port 8443

# get the fingerprint (the secondary ucp hosts need to verify the fingerprint of the primary)
sudo docker run --rm --name ucp \
-v /var/run/docker.sock:/var/run/docker.sock \
docker/ucp fingerprint | cut -d '=' -f 2 > fingerprint.log

# serve up the fingerprint
nohup python -m SimpleHTTPServer 8000 </dev/null >/dev/null 2>&1 &  

# DTR
sudo bash -c "$(sudo docker run docker/trusted-registry install)"

# SSL CERTS

# get the ssl cert for the docker1 host,
# and make sure centos knows about it
openssl s_client -connect $DOCKER1_IP \
-showcerts </dev/null 2>/dev/null \
| openssl x509 -outform PEM \
| sudo tee /etc/pki/ca-trust/source/anchors/$DOMAIN_NAME.crt
sudo update-ca-trust

# get the ssl cert for the docker1 host,
# and make sure docker knows about it
mkdir -p /etc/docker/certs.d/${DOCKER1_IP}
openssl s_client -connect $DOMAIN_NAME:443 \
-showcerts </dev/null 2>/dev/null \
| openssl x509 -outform PEM \
| sudo tee /etc/docker/certs.d/${DOCKER1_IP}/ca.crt
sudo /bin/systemctl restart docker.service
