#!/bin/bash

source ${SCRIPT_PATH}/scripts/supporting/common-environment.sh

docker run -it --rm \
docker/dtr remove --force-remove \
--ucp-url $UCP_URL \
--ucp-ca "$(cat ucp-ca.pem)" \
--ucp-username $UCP_USER --ucp-password $UCP_PASSWORD

sudo rm /etc/pki/ca-trust/source/anchors/${DTR_HOST}.crt
sudo rm -rf /etc/docker/certs.d/${DTR_HOST}:${DTR_HTTPS_PORT}

# docker run --rm \
# docker/dtr install \
# --ucp-url $UCP_URL \
# --ucp-ca "$(cat ucp-ca.pem)" \
# --ucp-username $UCP_USER --ucp-password $UCP_PASSWORD \
# --dtr-external-url $DTR_PUBLIC_IP:${DTR_HTTPS_PORT} \
# --replica-http-port ${DTR_HTTP_PORT} \
# --replica-https-port ${DTR_HTTPS_PORT}

source ${SCRIPT_PATH}/scripts/supporting/dtr.sh