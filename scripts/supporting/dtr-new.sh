#!/bin/bash

SCRIPT_PATH=/home/vagrant/sync

# DTR - Offline content
#wget https://packages.docker.com/dtr/1.4/dtr-1.4.3.tar
#docker load < dtr-1.4.3.tar

# DTR 2.x
# https://hub.docker.com/r/docker/dtr/
# The repository contains DTR 2.x and up.
# DTR 1.x
# https://hub.docker.com/r/docker/trusted-registry/
# For DTR 1.x see docker/trusted-registry.

sudo bash -c "$(sudo docker run docker/dtr)"
sleep 20

docker tag docker/dtr:2.0.2 docker/dtr:latest

UCP_HOST=172.28.128.7:8443
curl -k https://$UCP_HOST/ca > ucp-ca.pem

UCP_URL=$UCP_HOST
NODE_HOSTNAME=docker1
DTR_PUBLIC_IP=172.28.128.7:1337
USER=admin
PASSWORD=orca

docker run -it --rm \
  docker/dtr install \
   --debug \
   --ucp-username $USER --ucp-password $PASSWORD \
  --ucp-ca "$(cat ucp-ca.pem)"

  docker run -it --rm \
  docker/dtr remove \
   --debug \
   --ucp-username $USER --ucp-password $PASSWORD \
  --ucp-ca "$(cat ucp-ca.pem)"

# Install DTR
$ docker run -it --rm \
  docker/dtr install \
  --debug \
  --ucp-url $UCP_URL \
  --ucp-node $NODE_HOSTNAME \
  --dtr-external-url $DTR_PUBLIC_IP \
  --ucp-username $USER --ucp-password $PASSWORD \
  --ucp-ca "$(cat ucp-ca.pem)"