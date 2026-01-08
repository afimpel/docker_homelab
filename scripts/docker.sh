#!/bin/bash

############################################################
# Docker functions                                         #
############################################################

docker_up () {
  clear
  openCD $0
  touch www/dash/version.json
  rightH1 $YELLOW 'Startup containers' $WHITE '✔' "."
  date +'%s' > logs/startup.pid
  cd DOCKER/
  docker compose up -d
  if [ $? -ne 0 ]; then
    send_notify "Error: On start, docker compose up." "error" 16000 "critical"
    docker_down clear
    exit 1
  fi
  docker_bash "homelab-php8" "logs-chmod:root"
  docker_bash "homelab-php7" "logs-chmod:root"
  docker_bash "homelab-database" "logs-chmod:root"
  versionPHP7=$(docker_bash "homelab-php7" "php:root" -v | head -1 | cut -d " " -f 2)
  versionPHP8=$(docker_bash "homelab-php8" "php:root" -v | head -1 | cut -d " " -f 2)
  composerVersion7=$(docker_bash "homelab-php7" "composer:root" -V | head -1 | cut -d " " -f 3 | sed -E 's/\x1b\[[0-9;]*m//g')
  composerVersion8=$(docker_bash "homelab-php8" "composer:root" -V | head -1 | cut -d " " -f 3 | sed -E 's/\x1b\[[0-9;]*m//g')
  checkfile="\"startup.pid\""
  if [ -f "logs/makealias.pid" ]; then
    checkfile="$checkfile,\"makealias.pid\""
  fi
  dockerVersion=$(docker -v)
  dockerVersion=${dockerVersion//version/:}
  dockerVersion=$(echo $dockerVersion | cut -d ":" -f 2 | cut -d "," -f 1)
  
  dockerComposeVersion=$(docker compose version)
  dockerComposeVersion=${dockerComposeVersion//version/:}
  dockerComposeVersion=$(echo $dockerComposeVersion | cut -d ":" -f 2)
  gitinfo=$(git log -1 --pretty=format:"%an: %h - %s ( %cr )")
  echo -e "{ \"startup\":\"$(date)\",\"gitinfo\":\"$gitinfo\",\"username\":\"$USERNAME\",\"checkfile\":[$checkfile],\"version\":{\"php8\":\"$versionPHP8\", \"composer8\":\"$composerVersion8\", \"php7\":\"$versionPHP7\", \"composer7\":\"$composerVersion7\", \"docker\":\"Ver$dockerVersion\", \"dockerCompose\":\"Ver$dockerComposeVersion\"} }" | jq . > www/dash/version.json
  chmod 777 www/dash/version.json
}

docker_up_master () {
  colorize $WHITE "🗑 $LIGHT_RED$(rm -v DOCKER/docker-compose.override.yml)"
  docker_up
  generate-override
  docker_up
  timeExec=$(diffTime "$startExec0000")
  CUSTOM_RIGHT $WHITE "Done all:" $LIGHT_GRAY "$timeExec" $WHITE "✔" "." "✔" 0
  clear
  docker_bash "homelab-database" "logs-chmod:root"
  ln
  goaccess
  ln
  runonce_fn
 }

runonce_fn () {
  startExec0000=$(date +'%s')
  openCD $0
  if [ -f "logs/startup.pid" ]; then
    rightH1 $YELLOW 'Runonce' $WHITE '☐' "."
    echo -e "---\t\t ${COMPOSE_PROJECT_NAME^^} ✔ \t\t---" > logs/runonce_ALL.log 
    for script in config/runonce/*.sh ; do
        if [ -r "$script" ] ; then
                nombre_archivo=$(basename "${script}")
                nombre_base="${nombre_archivo%.*}"
                nuevo_nombre="${nombre_base}_bash.log"
                bash -c "bash $script > logs/runonce-$nuevo_nombre 2>&1"
                timeExec=$(diffTime "$startExec0000")
                echo -e "✔\t RUN: \t$script\n➤\t Time: \t$timeExec\n➤\t Size: \t$(du -h logs/runonce-$nuevo_nombre)\n" >> logs/runonce_ALL.log
                CUSTOM_LEFT $NC "bash $script" $BLUE "$timeExec" $LIGHT_GREEN "➤" " " "✔" "7"
        fi
    done 
    timeExec=$(diffTime "$startExec0000")
    CUSTOM_RIGHT $WHITE "Runonce Done:" $LIGHT_GRAY "$timeExec" $WHITE "✔" "." "✔" 0
    echo -e "Time excution: $timeExec." >> logs/runonce_ALL.log
  fi
}


docker_restart () {
  clear
  startExec0000=$(date +'%s')
  openCD $0
  if [ -f "logs/startup.pid" ]; then
    rightH1 $YELLOW 'Restart containers' $WHITE '⟳' "."
    date +'%s' > logs/startup.pid
    cd DOCKER/
    docker compose restart
    clear
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
      clear
      openCD $0
      startup=$(cat logs/startup.pid)
      cd logs
      if [ "$#" -gt 0 ] && [ "$1" == "clear" ]; then
          ln
          clearLogs
      fi
      openCD $0
      ln
      timeExec=$(diffTime "$startExec0002")
      send_notify "Stop & down all containers in $timeExec" "process-stop-symbolic"
      CUSTOM_RIGHT $WHITE "Done all:" $LIGHT_GRAY "DOCKER Down: $timeExec" $WHITE "✔" "." "✔" 0
      cd logs
      colorize $LIGHT_GREEN "✔ $LIGHT_RED$(rm -v startup.pid)"
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
      send_notify "Container: $Container $Command" "utilities-terminal.svg"
      CUSTOM_RIGHT $RED "Container: $Container $Command" $YELLOW "USR: $Usr" $WHITE '✔' "." '✔' 0
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
      if [ -f "logs/makealias.pid" ]; then
          echo -e " ➤ ${LIGHT_GREEN}${COMPOSE_PROJECT_NAME,,} up${NC}"
      else
          echo -e " ➤ ${LIGHT_GREEN}./homelab up${NC}"
      fi
    fi
  fi
  if [ "$Command" == "bash" ]; then
    footer
  fi
}