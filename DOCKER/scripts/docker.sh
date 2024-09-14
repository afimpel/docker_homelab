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
  echo -e " ${LIGTH_GREEN}✔${NC} WWW\t\t\t\t      ${GREEN}Https://www.${COMPOSE_PROJECT_NAME,,}.local/${NC}\n"
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
  if [ "$2" == "bash" ]; then
    header
    R1 $YELLOW "Container: $1 $2" $WHITE '✔' "."
    ln
    Usr=$3
  else
    parm3=$3
  fi
  Usr=""
  Container=$1
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