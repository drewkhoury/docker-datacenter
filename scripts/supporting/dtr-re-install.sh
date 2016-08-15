#!/bin/bash

set -x

export SCRIPT_PATH=/home/vagrant/sync
source ${SCRIPT_PATH}/scripts/supporting/common-environment.sh

echo "existing_replica_id = ${existing_replica_id}"

sudo chown vagrant ucp-ca.pem
sudo chown vagrant ucp_root_ca.pem

docker run --rm \
docker/dtr remove --force-remove \
--ucp-url $UCP_URL \
--ucp-ca "$(cat vagrant-ucp-ca.pem)" \
--ucp-username $UCP_USER --ucp-password $UCP_PASSWORD \
--existing-replica-id ${existing_replica_id} \
--replica-id ${existing_replica_id}

# sudo chown vagrant /etc/pki/ca-trust/source/anchors/${DTR_HOST}.crt
# sudo chown -r vagrant /etc/docker/certs.d/${DTR_HOST}:${DTR_HTTPS_PORT}

sudo rm /etc/pki/ca-trust/source/anchors/${DTR_HOST}.crt
sudo rm -rf /etc/docker/certs.d/${DTR_HOST}:${DTR_HTTPS_PORT}

source ${SCRIPT_PATH}/scripts/supporting/dtr.sh
