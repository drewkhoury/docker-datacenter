#!/bin/bash

DOMAIN=dtr.local
DTR_PORT=1337

# General DTR domain, settings and UCP bypass auth
echo "Configuring DTR domain, setting and to authorize UCP traffic"

cat <<EOF | sudo tee /usr/local/etc/dtr/hub.yml > /dev/null
load_balancer_http_port: 8080
load_balancer_https_port: ${DTR_PORT}
domain_name: "${DOMAIN}"
notary_server: ""
notary_cert: ""
notary_verify_cert: false
auth_bypass_ou: ""
extra_env:
HTTP_PROXY: ""
HTTPS_PROXY: ""
NO_PROXY: ""
disable_upgrades: false
release_channel: ""
EOF
# cant get this to work...
#auth_bypass_ca: "$(docker run --rm -v /var/run/docker.sock:/var/run/docker.sock --name ucp docker/ucp dump-certs --cluster -ca)"

echo "Stopping and Installing DRT"
docker run docker/trusted-registry:1.4.3 stop | sh
docker run docker/trusted-registry:1.4.3 install | sh
sleep 45

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
mkdir -p /etc/docker/certs.d/${DOMAIN}
openssl s_client -connect ${DOMAIN}:${DTR_PORT} \
-showcerts </dev/null 2>/dev/null \
| openssl x509 -outform PEM \
| sudo tee /etc/docker/certs.d/${DOMAIN}/ca.crt

# restart for new ssl certs
sudo update-ca-trust
sudo /bin/systemctl restart docker.service
sleep 10