#!/bin/bash

# vagrant up ddc_docker_dev
# vagrant ssh ddc_docker_dev -c 'chmod +x /home/vagrant/sync/presentation/demo/scripts/*.sh'

# vagrant ssh ddc_docker_dev -c '/home/vagrant/sync/presentation/demo/scripts/dev-push.sh v1'

# vagrant ssh ddc_docker_dev -c '/home/vagrant/sync/presentation/demo/scripts/dtr-org-setup.sh'

# vagrant ssh ddc_docker_dev -c '/home/vagrant/sync/presentation/demo/scripts/dev-push.sh all'


# set -x

function main()
{
  var1=$1

  export SCRIPT_PATH=/home/vagrant/sync
  export PRES_PATH=/home/vagrant/sync/presentation
  export IMAGE_TAG=${var1}

  source ${SCRIPT_PATH}/scripts/supporting/common-environment.sh

  # DOCKER1_IP variable defined in docker-compose.yml retrieved via source command above
  docker-compose -f ${PRES_PATH}/webB/docker-compose.yml build nginxProjectXYZ

  # docker-compose -f ${PRES_PATH}/webB/docker-compose.yml up -d nginxProjectXYZ
  # docker exec -it webb_nginxProjectXYZ_1  bash -c 'cat /usr/share/nginx/html/index.html'
  # docker-compose -f ${PRES_PATH}/webB/docker-compose.yml stop nginxProjectXYZ
  # docker-compose -f ${PRES_PATH}/webB/docker-compose.yml rm -v -f nginxProjectXYZ

  docker login -u userb -p userb ${DTR_URL}
}

start_command=$1
if [ -n "$start_command" ]; then
  if [ "$start_command" == "all" ]; then

    main "1.0.0"
    docker push ${DOCKER1_IP}:1337/devops/project-xyz:${IMAGE_TAG}

    main "2.0.0"
    docker push ${DOCKER1_IP}:1337/devops/project-xyz:${IMAGE_TAG}

    main "3.0.0"
    docker push ${DOCKER1_IP}:1337/devops/project-xyz:${IMAGE_TAG}
  fi
  if [ "$start_command" == "v1" ]; then
    main "1.0.0"
    docker push ${DOCKER1_IP}:1337/devops/project-xyz:${IMAGE_TAG}
    
  fi
fi


