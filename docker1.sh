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

# DTR - Offline content
#wget https://packages.docker.com/dtr/1.4/dtr-1.4.3.tar
#sudo docker load < dtr-1.4.3.tar

# DTR
sudo bash -c "$(sudo docker run docker/trusted-registry install)"

# SSL CERTS

# define the domain
DOMAIN=docker1

# https://docs.docker.com/v1.9/docker-trusted-registry/configuration/#installing-registry-certificates-on-client-docker-daemons
# Installing Registry certificates on client Docker daemons
# The default certificates do not have a trusted Certificate Authority,
# we will need to install them on each client Docker daemon host.
#
openssl s_client -connect ${DOMAIN}:443 \
-showcerts </dev/null 2>/dev/null \
| openssl x509 -outform PEM \
| sudo tee /etc/pki/ca-trust/source/anchors/${DOMAIN}.crt

# Using certificates for repository client verification
# https://docs.docker.com/engine/security/certificates/
#
# e.g `docker login`
#
mkdir -p /etc/docker/certs.d/${DOMAIN}
openssl s_client -connect ${DOMAIN}:443 \
-showcerts </dev/null 2>/dev/null \
| openssl x509 -outform PEM \
| sudo tee /etc/docker/certs.d/${DOMAIN}/ca.crt

# restart for new ssl certs
sudo update-ca-trust
sudo /bin/systemctl restart docker.service

# test
curl -v https://${DOMAIN}/login
curl -v https://${DOMAIN}/login --cacert /etc/pki/ca-trust/source/anchors/${DOMAIN}.crt --insecure
