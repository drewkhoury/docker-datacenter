#!/bin/bash

echo `date`
start=`date +%s`

# common scripts
export SCRIPT_PATH=/home/vagrant/sync

source ${SCRIPT_PATH}/scripts/supporting/common-environment.sh
source ${SCRIPT_PATH}/scripts/supporting/common.sh
source ${SCRIPT_PATH}/scripts/supporting/dtr-ssl.sh

docker pull busybox:latest
docker pull nginx:latest

echo `date`
end=`date +%s`

let deltatime=end-start
let hours=deltatime/3600
let minutes=(deltatime/60)%60
let seconds=deltatime%60
printf "Time spent: %d:%02d:%02d\n" $hours $minutes $seconds
