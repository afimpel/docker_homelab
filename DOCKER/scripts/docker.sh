#!/bin/bash

############################################################
# Docker functions                                         #
############################################################

docker_up () {
  R1 $YELLOW 'Startup containers' $WHITE '✔' "."
  ln
  cd DOCKER/
  docker compose up -d
  ln
}

docker_ps() {
  R1 $YELLOW 'List all containers' $WHITE '✔' "."
  ln
  cd DOCKER/
  docker compose ps -a
  ln
}

docker_logs() {
  R1 $YELLOW "Show containers logs : $1" $WHITE '✔' "."
  ln
  cd DOCKER/
  docker compose logs "$@"
  ln
}

docker_down() {
  R1 $YELLOW 'Stop & down all containers' $WHITE '■' "."
  ln
  cd DOCKER/
  docker compose down --remove-orphans
  if [ "$#" -gt 0 ] && [ "$1" == "clear" ]; then
      ln
      R1 $YELLOW 'Clear Logs' $WHITE '■' "."
      ln
      find ../ -type f -name "*.log"  -delete -exec echo removed "'{}'" \; 
  fi
  ln
}

docker_bash() {
  R1 $YELLOW 'Containers bash' $WHITE '✔' "."
  ln
  Container=$1
  Usr=$2
  if [ ${#Usr} -gt 0 ]; then
     docker exec -it -u $Usr $Container bash
  else
     docker exec -it $Container bash
  fi
  ln
}