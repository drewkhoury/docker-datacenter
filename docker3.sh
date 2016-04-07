#!/bin/bash

# install docker engine, and pull the ucp image
source /home/vagrant/sync/docker-engine.sh

# ucp
sudo docker run --rm -t --name ucp \
-e "UCP_ADMIN_USER=admin" -e "UCP_ADMIN_PASSWORD=orca" \
-v /var/run/docker.sock:/var/run/docker.sock \
-v /etc/hosts:/etc/hosts \
docker/ucp join \
--url https://${DOCKER1_IP}:8443 \
--fingerprint `curl -s http://docker1:8000/fingerprint.log` \
--replica --host-address ${DOCKER3_IP} \
--controller-port 8443

# # interlock 1 - works with boot2docker
# cd ~ && git clone https://github.com/ehazlett/interlock.git
# export SWARM_HOST=tcp://192.168.50.10:3376
# cd ~/interlock/docs/examples/nginx-swarm-machine/ && \
# docker-compose up -d interlock && docker-compose up -d nginx && \
# docker-compose up -d app && docker-compose scale app=4

# # interlock 2 - works with ucp
# cd ~ && git clone https://github.com/nicolaka/interlock-lbs.git
# export CONTROLLER_IP=192.168.50.10
# cd ~/interlock-lbs/interlock-nginx/ && docker-compose up -d

# # hack for interloack
# cat <<EOF | sudo tee /var/lib/docker/volumes/interlocknginx_nginx/_data/nginx.conf > /dev/null
# events {
#   worker_connections  4096;  ## Default: 1024
# }
# EOF

# # app
# # - also, update windows hosts file with `192.168.50.30 test.local`
# cat <<EOF | sudo tee /home/vagrant/interlock-lbs/interlock-nginx/docker-compose-app.yaml > /dev/null
# app:
#     image: ehazlett/docker-demo:latest
#     ports:
#         - 80
#     labels:
#         - "interlock.hostname=test"
#         - "interlock.domain=local"
# EOF
