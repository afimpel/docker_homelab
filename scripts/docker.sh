#!/bin/bash

############################################################
# Docker functions                                         #
############################################################

docker_up () {
  colorize $YELLOW ' > Startup containers'
  ln
  ln
  cd DOCKER/
  docker compose up -d
  ln
}

docker_ps() {
  colorize $YELLOW ' > List all containers'
  ln
  ln
  cd DOCKER/
  docker compose ps
  ln
}

docker_logs() {
  colorize $YELLOW ' > Show containers logs'
  ln
  ln
  cd DOCKER/
  docker compose logs "$@"
  ln
}

docker_down() {
  colorize $YELLOW ' > Stop & down all containers'
  ln
  ln
  cd DOCKER/
  docker compose down --remove-orphans
  ln
}

docker_bash() {
  colorize $YELLOW ' > Containers bash'
  ln
  ln
  C=$1
  docker exec -it $C bash
  ln
}