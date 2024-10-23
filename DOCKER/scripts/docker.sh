#!/bin/bash

############################################################
# Docker functions                                         #
############################################################

docker_up () {
  openCD $0
  rightH1 $YELLOW 'Startup containers' $WHITE '✔' "."
  date +'%s' > logs/startup.pid
  cd DOCKER/
  docker compose up -d
}
docker_restart () {
  openCD $0
  if [ -f "logs/startup.pid" ]; then
    rightH1 $YELLOW 'Restart containers' $WHITE '⟳' "."
    date +'%s' > logs/startup.pid
    cd DOCKER/
    docker compose restart
  else
      CUSTOM_RIGHT $NC 'Restart containers' $LIGHT_CYAN "There is nothing to do" $WHITE "☐" " " "☐" 0
      ln
      help
  fi  
}

docker_ps() {
  openCD $0
  rightH1 $YELLOW 'List all containers' $WHITE '✔' "."
  cd DOCKER/
  docker compose ps -a
}

docker_logs() {
  openCD $0
  rightH1 $YELLOW "Show containers logs : $1" $WHITE '✔' "."
  cd DOCKER/
  docker compose logs "$@"
}

docker_down() {
  openCD $0
  if [ -f "logs/startup.pid" ]; then
      startup
      ln
      rightH1 $YELLOW 'Stop & down all containers' $WHITE "☐" "."
      cd DOCKER/
      docker compose down --remove-orphans
      openCD $0
      cd logs
      colorize $LIGHT_GREEN "✔ $LIGHT_RED$(rm -v startup.pid)"
      if [ "$#" -gt 0 ] && [ "$1" == "clear" ]; then
          ln
          clearLogs
      fi
  else
      CUSTOM_RIGHT $NC 'Stop & down all containers' $LIGHT_CYAN "There is nothing to do" $WHITE "☐" " " "☐" 0
      ln
      help
  fi
}

docker_bash() {
  OLDOLDPWD=$OLDPWD
  openCD $0
  Usr=""
  Container=$1
  parm3=""
  if [ -f "logs/startup.pid" ]; then
    if [ "$2" == "bash" ]; then
      header
      rightH1 $YELLOW "Container: $1 $2" $WHITE '✔' "."
      Usr=$3
    else
      parm3="${@: 3}"
    fi
    workdir=""
    if [[ $OLDOLDPWD == *"/www"* ]]; then
      workdir=" -w ${OLDOLDPWD/$PWD/\/var}"
    fi
    if [ ${#Usr} -gt 0 ]; then
      docker exec$workdir -it -u $Usr $Container $2
    else
      docker exec$workdir -it $Container $2 $parm3
    fi
  else
    if [ "$2" == "bash" ]; then
      header
      rightH1 $RED "Docker OFF" $LIGHT_RED "✘" "."
    fi
    colorize $CYAN "./homelab up"
  fi
  if [ "$2" == "bash" ]; then
    footer
  fi
}