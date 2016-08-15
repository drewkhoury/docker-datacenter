#!/bin/bash

# install package etc
##############################################################

# extra bits
sudo yum install git wget -y

wget -q https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
chmod +x jq-linux64

# install docker engine
source ${SCRIPT_PATH}/scripts/supporting/docker-engine.sh

