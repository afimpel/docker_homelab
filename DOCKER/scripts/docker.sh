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
  docker_bash "homelab-php8" "logs-chmod:root"
  docker_bash "homelab-php7" "logs-chmod:root"
  docker_bash "homelab-database" "logs-chmod:root"
}

runonce_fn () {
  startExec0000=$(date +'%s')
  openCD $0
  if [ -f "logs/startup.pid" ]; then
    rightH1 $YELLOW 'Runonce' $WHITE '☐' "."
    echo -e "---\t\t ${COMPOSE_PROJECT_NAME^^} ✔ \t\t---" > logs/runonce.log 
    for script in config/runonce/*.sh ; do
        if [ -r "$script" ] ; then
                echo -e "✔ RUN:\t\t$script" >> logs/runonce.log
                bash -c "bash $script" >> logs/runonce.log 2>>logs/runonce.log 
                timeExec=$(diffTime "$startExec0000")
                sed -i 's/<br>/\n/g' logs/runonce.log
                CUSTOM_LEFT $NC "bash $script" $BLUE "$timeExec" $LIGHT_GREEN "➤" " " "✔" "7"
                echo -e "\n---\t\t $(date) \t\t---\n" >> logs/runonce.log 

        fi
    done 
  fi
}


docker_restart () {
  startExec0000=$(date +'%s')
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
  timeExec=$(diffTime "$startExec0000")
  CUSTOM_RIGHT $WHITE "Done all:" $LIGHT_GRAY "$timeExec" $WHITE "✔" "." "✔" 0
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
  startExec0002=$(date +'%s')
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
      timeExec=$(diffTime "$startExec0002")
      CUSTOM_RIGHT $WHITE "Done all:" $LIGHT_GRAY "DOCKER Down: $timeExec" $WHITE "✔" "." "✔" 0
  else
      CUSTOM_RIGHT $NC 'Stop & down all containers' $LIGHT_CYAN "There is nothing to do" $WHITE "☐" " " "☐" 0
      ln
      help
  fi 
}

docker_bash() {
  OLDOLDPWD=$OLDPWD
  openCD $0
  Container=$1
  Command=$(echo "$2" | cut -d ":" -f 1)
  Usr=$(echo "$2" | cut -d ":" -f 2)
  parm3=""
  if [ -f "logs/startup.pid" ]; then
    if [ "$Command" == "bash" ]; then
      header
      rightH1 $YELLOW "Container: $Container $Command" $WHITE '✔' "."
      #Usr=$3
    else
      parm3="${@: 3}"
    fi
    workdir=""
    if [[ $OLDOLDPWD == *"/www"* ]]; then
      workdir=" -w ${OLDOLDPWD/$PWD/\/var}"
    fi
    docker exec$workdir -it -u $Usr $Container $Command $parm3
  else
    if [ "$Command" == "bash" ]; then
      header
      rightH1 $RED "Docker OFF" $LIGHT_RED "✘" "."
    fi
    colorize $CYAN "./homelab up"
  fi
  if [ "$Command" == "bash" ]; then
    footer
  fi
}