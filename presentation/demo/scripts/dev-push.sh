#!/bin/bash

# set -x

function main()
{
  version=$1

  DTR_ORG=devops
  DTR_REPO=project-xyz
  DTR_USER=drew
  DTR_PASSWORD=drew
  DTR_TEAM=dev

  export SCRIPT_PATH=/home/vagrant/sync
  export PRES_PATH=/home/vagrant/sync/presentation
  export IMAGE_TAG=${version}

  source ${SCRIPT_PATH}/scripts/supporting/common-environment.sh

  # DOCKER1_IP variable defined in docker-compose.yml 
  # retrieved via source command above
  if [ "$version" == "3.0.0" ] ; then
    docker-compose -f ${PRES_PATH}/webB/docker-compose.yml build nginxProjectXYZ
  else
    docker-compose -f ${PRES_PATH}/webA/docker-compose.yml build nginxProjectXYZ
  fi 

  docker login -u ${DTR_USER} -p ${DTR_PASSWORD} ${DTR_URL}
}

start_command=$1
if [ -n "$start_command" ]; then
  if [ "$start_command" == "v1v2" ]; then

    main "1.0.0"
    docker push ${DOCKER1_IP}:1337/${DTR_ORG}/${DTR_REPO}:${IMAGE_TAG}

    main "2.0.0"
    docker push ${DOCKER1_IP}:1337/${DTR_ORG}/${DTR_REPO}:${IMAGE_TAG}
  fi
  if [ "$start_command" == "v3" ]; then
    main "3.0.0"
    docker push ${DOCKER1_IP}:1337/${DTR_ORG}/${DTR_REPO}:${IMAGE_TAG}
  fi
fi


