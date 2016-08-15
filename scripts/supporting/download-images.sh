#!/bin/bash

# set -x

echo '=============================================================='
echo '================= Download images ============================'
echo '=============================================================='


# download images on your local host,
# so you don't need to download them,
# each time you vagrant up

images_path=${SCRIPT_PATH}/images

if [ ! -d "$images_path" ]; then
	mkdir $images_path
fi

UCP_NAME=ucp
DTR_NAME=dtr

# eg ucp-1.1.2_dtr-2.0.2.tar.gz
VERSION=${UCP_NAME}-${UCP_VERSION}_${DTR_NAME}-${DTR_VERSION}

if [ ! -f "$images_path/${VERSION}.tar.gz" ]; then
	echo 'downloading the following to your host machine... '${VERSION}'.tar.gz'
	wget https://packages.docker.com/caas/${VERSION}.tar.gz -O $images_path/${VERSION}.tar.gz
else
	echo 'you are good to go, images already downloaded!'
fi

