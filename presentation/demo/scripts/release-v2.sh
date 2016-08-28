#!/bin/bash

set -x

export SCRIPT_PATH=/home/vagrant/sync
source ${SCRIPT_PATH}/scripts/supporting/common-environment.sh

mkdir -p /home/vagrant/xyz2

cp ${SCRIPT_PATH}/presentation/demo/release-v2/docker-compose.yml /home/vagrant/xyz2

cd /home/vagrant/xyz2
docker-compose config
docker-compose up -d