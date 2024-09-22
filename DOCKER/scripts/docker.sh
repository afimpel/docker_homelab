#!/bin/bash

############################################################
# Docker functions                                         #
############################################################

docker_up () {
  R1 $YELLOW 'Startup containers' $WHITE '✔' "."
  date +'%A, %d/%B/%Y | %H:%M:%S ( 00%u )' > logs/startup.log
  cd DOCKER/
  docker compose up -d
}
docker_restart () {
  R1 $YELLOW 'Restart containers' $WHITE '⟳' "."
  date +'%A, %d/%B/%Y | %H:%M:%S ( 00%u )' > logs/startup.log
  cd DOCKER/
  docker compose restart
}

docker_ps() {
  R1 $YELLOW 'List all containers' $WHITE '✔' "."
  cd DOCKER/
  docker compose ps -a
}

docker_logs() {
  R1 $YELLOW "Show containers logs : $1" $WHITE '✔' "."
  cd DOCKER/
  docker compose logs "$@"
}

docker_down() {
  cd $(dirname $0)
  if [ -f "logs/startup.log" ]; then
      startup
      ln
      R1 $YELLOW 'Stop & down all containers' $WHITE '■' "."
      cd DOCKER/
      docker compose down --remove-orphans
      colorize $LIGTH_GREEN "✔ $RED$(rm -v $(dirname $0)/logs/startup.log)"
      if [ "$#" -gt 0 ] && [ "$1" == "clear" ]; then
          ln
          clear
      fi
  else
      CUSTOM $NC 'Stop & down all containers' $LIGTH_CYAN "There is nothing to do" $WHITE "✔" " " "✔" 0
  fi
}

docker_bash() {
  Usr=""
  Container=$1
  parm3=""
  if [ -f "logs/startup.log" ]; then
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
  else
    if [ "$2" == "bash" ]; then
      header
      R1 $RED "Docker OFF" $LIGTH_RED "✘" "."
    fi
    colorize $CYAN "./homelab up"
  fi
  if [ "$2" == "bash" ]; then
    footer
  fi
}