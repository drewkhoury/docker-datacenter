#!/bin/bash

# install docker cs
sudo rpm --import "https://pgp.mit.edu/pks/lookup?op=get&search=0xee6d536cf7dc86e2d7d56f59a178ac6c6238f52e"
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://packages.docker.com/1.11/yum/repo/main/centos/7
sudo yum install docker-engine -y

# start
sudo service docker start

## TODO make a service so start on vagrant up
# sudo service docker start

#  allow vagrant user to run docker commands
sudo usermod -a -G docker vagrant
sudo chown -R vagrant:root /var/lib/docker/
sudo chown -R vagrant:root /etc/docker/

# docker compose
curl -Ls https://github.com/docker/compose/releases/download/1.8.0/docker-compose-`uname -s`-`uname -m` > docker-compose
sudo mv docker-compose /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo chown root:docker /usr/local/bin/docker-compose

# extra bits
sudo yum install git wget -y

# discover the docker ips
# docker has an issue with trying to join
# via a hacked /etc/hosts entry
export DOCKER1_IP=`cat /etc/hosts | grep docker1 | cut -f1`
export DOCKER2_IP=`cat /etc/hosts | grep docker2 | cut -f1`
export DOCKER3_IP=`cat /etc/hosts | grep docker3 | cut -f1`

cat <<EOF | sudo tee -a /etc/hosts > /dev/null
${DOCKER1_IP} dtr.local
EOF