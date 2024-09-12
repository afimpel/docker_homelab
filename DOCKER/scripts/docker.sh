#!/bin/bash

############################################################
# Docker functions                                         #
############################################################

docker_up () {
  h1 $YELLOW 'Startup containers ' '✔' "."
  ln
  cd DOCKER/
  docker compose up -d
  ln
}

docker_ps() {
  h1 $YELLOW 'List all containers ' '✔' "."
  ln
  cd DOCKER/
  docker compose ps -a
  ln
}

docker_logs() {
  h1 $YELLOW "Show containers logs : $1 " '✔' "."
  ln
  cd DOCKER/
  docker compose logs "$@"
  ln
}

docker_down() {
  h1 $YELLOW 'Stop & down all containers ' '✔' "."
  ln
  cd DOCKER/
  docker compose down --remove-orphans
  if [ "$#" -gt 0 ] && [ "$1" == "clear" ]; then
      ln
      h1 $YELLOW 'Clear Logs ' '✔' "."
      ln
      find ../ -type f -name "*.log"  -delete -exec echo removed "'{}'" \; 
  fi
  ln
}

docker_bash() {
  h1 $YELLOW 'Containers bash' '✔' "."
  ln
  C=$1
  docker exec -it $C bash
  ln
}