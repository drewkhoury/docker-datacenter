#!/bin/bash

# discover the docker ips
# docker has an issue with trying to join
# via a hacked /etc/hosts entry
export DOCKER1_IP=`cat /etc/hosts | grep docker1 | cut -f1`
export DOCKER2_IP=`cat /etc/hosts | grep docker2 | cut -f1`
export DOCKER3_IP=`cat /etc/hosts | grep docker3 | cut -f1`

#DOMAIN=dtr.local
DOMAIN=$DOCKER1_IP
DTR_PORT=1337

echo "Configuring certs"

# https://docs.docker.com/v1.9/docker-trusted-registry/configuration/#installing-registry-certificates-on-client-docker-daemons
# Installing Registry certificates on client Docker daemons
# The default certificates do not have a trusted Certificate Authority,
# we will need to install them on each client Docker daemon host.
#
openssl s_client -connect ${DOMAIN}:${DTR_PORT} \
-showcerts </dev/null 2>/dev/null \
| openssl x509 -outform PEM \
| sudo tee /etc/pki/ca-trust/source/anchors/${DOMAIN}.crt

# Using certificates for repository client verification
# https://docs.docker.com/engine/security/certificates/
#
# e.g `docker login`
#
sudo mkdir -p /etc/docker/certs.d/${DOMAIN}:${DTR_PORT}
openssl s_client -connect ${DOMAIN}:${DTR_PORT} \
-showcerts </dev/null 2>/dev/null \
| openssl x509 -outform PEM \
| sudo tee /etc/docker/certs.d/${DOMAIN}:${DTR_PORT}/ca.crt

# restart for new ssl certs
sudo update-ca-trust

# dtr kind of epic fails if we restart the docker service ...
#sudo /bin/systemctl restart docker.service

sleep 10