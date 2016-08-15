#!/bin/bash

source ${SCRIPT_PATH}/scripts/supporting/common-environment.sh
source ${SCRIPT_PATH}/scripts/supporting/common.sh
source ${SCRIPT_PATH}/scripts/supporting/download-images.sh

echo 'docker images (before docker load of sync/images/*)...'
docker images

for i in sync/images/*
do
    if [ -f "$i" ]; then
        echo 'loading images found locally...' $i
        docker load < $i
    fi
done

echo "tagging loaded images as latest to stop/avoid a new UCP/DTR release potentially breaking project"
docker tag docker/ucp:${UCP_VERSION} docker/ucp:latest
docker tag docker/dtr:${DTR_VERSION} docker/dtr:latest

echo 'docker images (after docker load of sync/images/*)...'
docker images