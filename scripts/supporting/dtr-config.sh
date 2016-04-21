#!/bin/bash

SCRIPT_PATH=/home/vagrant/sync
DOMAIN=dtr.local
DTR_PORT=1337

# Injecting License
echo "Configuring DTR - Injecting License"
curl -Lik \
	-X PUT https://${DOMAIN}:${DTR_PORT}/api/v0/admin/settings/license \
	-H 'Content-Type: application/json; charset=UTF-8' \
	-H 'Accept: */*' \
	-H 'X-Requested-With: XMLHttpRequest' \
	--data-binary @${SCRIPT_PATH}/docker_subscription.lic
sleep 10

# Creating Admin User
echo "Configuring DTR - Creating Admin User"
curl -k -Lik \
     -X PUT https://${DOMAIN}:${DTR_PORT}/api/v0/admin/settings/auth \
     -H 'Content-Type: application/json; charset=UTF-8' \
     -H 'Accept: */*' \
     -H 'X-Requested-With: XMLHttpRequest' \
     --data-binary '{"method":"managed","managed":{"users":[{"username":"admin","password":"adminadmin","isNew":true,"isAdmin":true,"isReadWrite":false,"isReadOnly":false,"teamsChanged":true}]}}'
sleep 15

# configure ucp
echo "Configuring UCP to use DTR"
wget -q https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
chmod +x jq-linux64
TOKEN=$(curl -k -c jar https://docker1:8443/auth/login -d '{"username": "admin", "password": "orca"}' -X POST -s | ./jq-linux64 -r ".auth_token")
curl -k -s -c jar -H "Authorization: Bearer ${TOKEN}" https://docker1:8443/api/config/registry -X POST --data "{\"url\": \"https://${DOMAIN}:${DTR_PORT}\", \"insecure\":false}"
curl -k -s -H "Authorization: Bearer ${TOKEN}" https://docker1:8443/api/clientbundle -X POST > ~/admin_bundle.zip
