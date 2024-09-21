#!/bin/bash

############################################################
# Docker functions                                         #
############################################################

docker_up () {
  R1 $YELLOW 'Startup containers' $WHITE '✔' "."
  cd DOCKER/
  docker compose up -d
  www
  ln
}
docker_restart () {
  R1 $YELLOW 'Restart containers' $WHITE '✔' "."
  cd DOCKER/
  docker compose restart
  ln
}

docker_ps() {
  R1 $YELLOW 'List all containers' $WHITE '✔' "."
  cd DOCKER/
  docker compose ps -a
  ln
}

docker_logs() {
  R1 $YELLOW "Show containers logs : $1" $WHITE '✔' "."
  cd DOCKER/
  docker compose logs "$@"
  ln
}

docker_down() {
  R1 $YELLOW 'Stop & down all containers' $WHITE '■' "."
  cd DOCKER/
  docker compose down --remove-orphans
  if [ "$#" -gt 0 ] && [ "$1" == "clear" ]; then
      ln
      clear
  fi
}

docker_bash() {
  Usr=""
  Container=$1
  parm3=""
  if [ "$2" == "bash" ]; then
    header
    R1 $YELLOW "Container: $1 $2" $WHITE '✔' "."
    Usr=$3
  else
    parm3="${@: 3}"
  fi
  if [ ${#Usr} -gt 0 ]; then
     docker exec -it -u $Usr $Container $2
  else
     docker exec -it $Container $2 $parm3
  fi
  if [ "$2" == "bash" ]; then
    ln
    footer
  fi
}