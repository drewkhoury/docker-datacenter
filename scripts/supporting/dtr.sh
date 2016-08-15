#!/bin/bash

echo '=============================================================='
echo '=================== Install DTR =============================='
echo '=============================================================='

# get ucp certs
curl -k https://$UCP_URL/ca > ucp-ca.pem

docker run --rm \
    docker/dtr install \
    --ucp-url $UCP_URL \
    --ucp-ca "$(cat ucp-ca.pem)" \
    --ucp-username $UCP_USER --ucp-password $UCP_PASSWORD \
    --dtr-external-url $DTR_PUBLIC_IP:${DTR_HTTPS_PORT} \
    --replica-http-port ${DTR_HTTP_PORT} \
    --replica-https-port ${DTR_HTTPS_PORT}
sleep 20

# some inspiration taken from:
# https://blog.docker.com/2016/04/docker-datacenter-ddc-in-a-box/

# reconfigure dtr to work with a specific ssl
source ${SCRIPT_PATH}/scripts/supporting/dtr-ssl.sh

echo "Configuring DTR to trust UCP"
docker run --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    --name ucp \
    docker/ucp dump-certs \
    --cluster --ca > ucp_root_ca.pem
DTR_CONFIG_DATA="{\"authBypassCA\":\"$(cat ucp_root_ca.pem | sed ':begin;$!N;s|\n|\\n|;tbegin')\"}"
curl -u admin:orca -k  -H "Content-Type: application/json" \
    https://${DTR_URL}/api/v0/meta/settings -X POST --data-binary "$DTR_CONFIG_DATA"

echo "Configuring UCP to use DTR"
TOKEN=$(curl -k -c jar https://${UCP_URL}/auth/login -d '{"username": "admin", "password": "orca"}' -X POST -s | ./jq-linux64 -r ".auth_token")
UCP_CONFIG_DATA="{\"url\": \"https://${DTR_URL}\", \"insecure\":false}"
curl -k -s -c jar -H "Authorization: Bearer ${TOKEN}" \
    https://${UCP_URL}/api/config/registry -X POST --data "$UCP_CONFIG_DATA"

# make the ucp cert bundle available on the host
curl -k -s -H "Authorization: Bearer ${TOKEN}" https://${UCP_URL}/api/clientbundle -X POST > ~/admin_bundle.zip

# push image
source ${SCRIPT_PATH}/scripts/supporting/dtr-push-image.sh
