#!/bin/bash

# download images on your local host,
# so you don't need to download them,
# each time you vagrant up

if [ ! -d "images" ]; then
	mkdir images
fi

VERSION=ucp-1.1.2_dtr-2.0.3
if [ ! -f "images/${VERSION}.tar.gz" ]; then
	echo 'downloading the following to your host machine... '${VERSION}'.tar.gz'
    wget https://packages.docker.com/caas/${VERSION}.tar.gz -O images/${VERSION}.tar.gz
else
	echo 'you are good to go, images already downloaded!'
fi

