#!/bin/bash

# install docker cs
sudo rpm --import "https://pgp.mit.edu/pks/lookup?op=get&search=0xee6d536cf7dc86e2d7d56f59a178ac6c6238f52e"
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://packages.docker.com/1.10/yum/repo/main/centos/7
sudo yum install docker-engine -y

# debug
sudo systemctl daemon-reload
sudo systemctl show docker --property Environment
# sudo systemctl daemon-reload; sudo service docker restart; sudo systemctl show docker --property Environment

# start
sudo service docker start

# get ucp image
sudo docker pull docker/ucp

#  allow vagrant user to run docker commands
sudo usermod -a -G docker vagrant
sudo chown -R vagrant:root /var/lib/docker/

# docker compose
curl -Ls https://github.com/docker/compose/releases/download/1.6.2/docker-compose-`uname -s`-`uname -m` > docker-compose
sudo mv docker-compose /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo chown root:docker /usr/local/bin/docker-compose

# git
sudo yum install git -y

# discover the docker1 ip (joining to a primary requires 
# 						   a legit address and an /etc/hosts hack won't cut it)
export DOCKER1_IP=`cat /etc/hosts | grep docker1 | cut -f1`
export DOCKER2_IP=`cat /etc/hosts | grep docker2 | cut -f1`
export DOCKER3_IP=`cat /etc/hosts | grep docker3 | cut -f1`