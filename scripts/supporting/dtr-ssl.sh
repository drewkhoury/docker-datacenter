#!/bin/bash

echo "Configuring certs"

# https://docs.docker.com/v1.9/docker-trusted-registry/configuration/#installing-registry-certificates-on-client-docker-daemons
# Installing Registry certificates on client Docker daemons
# The default certificates do not have a trusted Certificate Authority,
# we will need to install them on each client Docker daemon host.
#
openssl s_client -connect ${DTR_HOST}:${DTR_HTTPS_PORT} \
-showcerts </dev/null 2>/dev/null \
| openssl x509 -outform PEM \
| sudo tee /etc/pki/ca-trust/source/anchors/${DTR_HOST}.crt
sudo update-ca-trust

# Using certificates for repository client verification
# https://docs.docker.com/engine/security/certificates/
#
# e.g `docker login`
#
sudo mkdir -p /etc/docker/certs.d/${DTR_HOST}:${DTR_HTTPS_PORT}
openssl s_client -connect ${DTR_HOST}:${DTR_HTTPS_PORT} \
-showcerts </dev/null 2>/dev/null \
| openssl x509 -outform PEM \
| sudo tee /etc/docker/certs.d/${DTR_HOST}:${DTR_HTTPS_PORT}/ca.crt

# dtr kind of epic fails if we restart the docker service ...
#sudo /bin/systemctl restart docker.service
#sleep 10