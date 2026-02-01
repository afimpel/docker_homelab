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
    docker_down
    exit 1
  fi
  directory_cli=$PWD
  docker_bash "homelab-php8" "logs-chmod:root"
  docker_bash "homelab-php7" "logs-chmod:root"
  docker_bash "homelab-database" "logs-chmod:root"
}

generate_version() {
  openCD $0
  directory_cli=$PWD
  if [ -f "logs/startup.pid" ]; then
    rightH1 $YELLOW 'Generate version file' $WHITE '✔' "."
    versionPHP7=$(docker_bash "homelab-php7" "php:root" -v | head -1 | cut -d " " -f 2)
    versionPHP8=$(docker_bash "homelab-php8" "php:root" -v | head -1 | cut -d " " -f 2)
    supervisordVersion7=$(docker_bash "homelab-php7" "supervisord:root" -v | head -1 | sed 's/[[:space:]]*$//')
    supervisordVersion8=$(docker_bash "homelab-php8" "supervisord:root" -v | head -1 | sed 's/[[:space:]]*$//')
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
    gitinfo=$(git log -1 --pretty=format:"%an: %s ( %h / %cr )")
    startupFile=$(cat logs/startup.pid)
    echo -e "{ \"startup\":$startupFile,\"gitinfo\":\"$gitinfo\",\"username\":\"$USERNAME\",\"checkfile\":[$checkfile],\"version\":{\"php8\":\"$versionPHP8\", \"composer8\":\"$composerVersion8\", \"supervisord8\":\"$supervisordVersion8\", \"php7\":\"$versionPHP7\", \"composer7\":\"$composerVersion7\", \"supervisord7\":\"$supervisordVersion7\", \"docker\":\"Ver$dockerVersion\", \"dockerCompose\":\"Ver$dockerComposeVersion\"} }" | jq . > www/dash/version.json
    chmod 777 www/dash/version.json
  fi
}

docker_updates () {
  directory_cli=$PWD
  if [ "$AUTO_UPDATE_CONTAINERS" = true ] ; then
    lastUpdateFile="logs/last_update.pid"
    currentDate=$(date +%s)
    if [ -f "$lastUpdateFile" ]; then
      lastUpdate=$(cat "$lastUpdateFile")
    else
      lastUpdate=0
    fi
    daysDiff=$(( (currentDate - lastUpdate) / 86400 ))
    if [ $daysDiff -ge $AUTO_UPDATE_DAYS ]; then
      local CONTENEDORES=(
        "nginx:alpine|nginx:alpine"
        "redis/redisinsight:latest|redis/redisinsight:latest"
        "local:php-$phpVersion8|php:$phpVersion8"
        "local:php-$phpVersion7|php:$phpVersion7"
        "afimpelcom/adminer:latest|adminer:latest"
        "mariadb:latest|mariadb:latest"
        "valkey:alpine|valkey:alpine"
        "local:goaccess-$COMPOSE_PROJECT_NAME|alpine:latest"
        "axllent/mailpit:latest|axllent/mailpit:latest"
      )
      for item in "${CONTENEDORES[@]}"; do
        NOMBRE=$(echo "$item" | cut -d'|' -f1)
        IMAGEN=$(echo "$item" | cut -d'|' -f2)
        rightH1 $YELLOW "Update image: $NOMBRE" $WHITE '✔' "."
        FECHA_ACTUAL=$(docker inspect --format='{{.Created}}' "$NOMBRE" 2>/dev/null)
        docker pull "$IMAGEN"
        FECHA_NUEVA=$(docker inspect --format='{{.Created}}' "$IMAGEN" 2>/dev/null)
        if [ "$FECHA_ACTUAL" != "$FECHA_NUEVA" ]; then
          if [[ "$FECHA_NUEVA" > "$FECHA_ACTUAL" ]]; then
            rightH1 $YELLOW "Image updated: $NOMBRE" $WHITE '✔' "."
            if [ "$NOMBRE" != "$IMAGEN" ]; then
              docker rmi "$NOMBRE"
            fi
          fi
        else
          rightH1 $YELLOW "Image not updated: $NOMBRE" $WHITE '✔' "."
        fi
      done
      clear
      date +%s > "$lastUpdateFile"
    fi
  fi
}

docker_up_master () {
  directory_cli=$PWD
  colorize $WHITE "🗑 $LIGHT_RED$(rm -v DOCKER/docker-compose.override.yml)"
  docker_up
  generate-override
  docker_up
  CUSTOM_RIGHT $WHITE "docker image prune" $LIGHT_GRAY "360h" $WHITE "✔" "." "✔" 0
  docker image prune -a --filter "until=360h" -f
  timeExec=$(diffTime "$startExec0000")
  CUSTOM_RIGHT $WHITE "Done all:" $LIGHT_GRAY "$timeExec" $WHITE "✔" "." "✔" 0
  clear
  docker_bash "homelab-database" "logs-chmod:root"
  ln
  goaccess
  ln
  runonce_fn
  ln
  generate_version
}

runonce_fn () {
  directory_cli=$PWD
  startExec0000=$(date +'%s')
  openCD $0
  if [ -f "logs/startup.pid" ]; then
    rightH1 $YELLOW 'Runonce' $WHITE '☐' "."
    DATETIME="$(date +%Y%m%d)"
    echo -e "---\t\t ✔ \t${COMPOSE_PROJECT_NAME^^}\t | \t $(date) \t ✔ \t\t---\n" > logs/runonce/${DATETIME}-00_ALL.log
    rm -v logs/runonce/*-50*.log >> logs/runonce/${DATETIME}-00_ALL.log 2>&1
    for script in config/runonce/*.sh ; do
        if [ -r "$script" ] ; then
                CUSTOM_LEFT $NC "bash $script" $BLUE "" $LIGHT_GREEN "➤" " " "⏲" 7
                startExec0001=$(date +'%s')
                nombre_archivo=$(basename "${script}")
                nombre_base="${nombre_archivo%.*}"
                nuevo_nombre="${DATETIME}-50${nombre_base}.log"
                echo -e "\n---\t\t ✔\t RUN: \tbash $script\t | \t $(date) \t ✔ \t\t---\n" > logs/runonce/$nuevo_nombre
                bash -c "bash $script > logs/runonce/int_$nuevo_nombre 2>&1"
                echo -e "----------- $(date '+%Y-%m-%d %H:%M:%S') -----------\n✔\t RUN: \tbash $script ➤\n" >> logs/runonce/${DATETIME}-00_ALL.log
                cat logs/runonce/int_$nuevo_nombre >> logs/runonce/${DATETIME}-00_ALL.log
                cat logs/runonce/int_$nuevo_nombre >> logs/runonce/$nuevo_nombre
                timeExec0=$(diffTime "$startExec0001")
                echo -e "\n➤\t Time:\t\t$timeExec0\n---\t\t ✔\t DONE: \t$script\t | \t $(date) \t ✔ \t\t---" >> logs/runonce/$nuevo_nombre
                echo " " >> logs/runonce/${DATETIME}-00_ALL.log
                rm -v logs/runonce/int_$nuevo_nombre >> logs/runonce/${DATETIME}-00_ALL.log 2>&1
                echo -e "➤\t Time: \t$timeExec0\n➤\t Size: \t$(du -h logs/runonce/$nuevo_nombre)\n----------- $(date '+%Y-%m-%d %H:%M:%S') -----------\n" >> logs/runonce/${DATETIME}-00_ALL.log
                CUSTOM_LEFT $NC "LOG: $nuevo_nombre" $BLUE "Time: $timeExec0 / Size: $(du -sh logs/runonce/$nuevo_nombre | awk '{print $1}')" $LIGHT_GREEN "➤" " " "✔" 12
                echo " "
        fi
    done 
    timeExec=$(diffTime "$startExec0000")
    CUSTOM_LEFT $NC "LOG: ${DATETIME}-00_ALL.log" $BLUE "Size: $(du -sh logs/runonce/${DATETIME}-00_ALL.log | awk '{print $1}')" $LIGHT_GREEN "➤" " " "✔" 7
    CUSTOM_RIGHT $WHITE "Runonce Done:" $LIGHT_GRAY "$timeExec" $WHITE "✔" "." "✔" 0
    echo -e "\nTime excution: $timeExec." >> logs/runonce/${DATETIME}-00_ALL.log
    echo -e "➤\t Size: \t$(du -h logs/runonce/${DATETIME}-00_ALL.log)\n----------- $(date '+%Y-%m-%d %H:%M:%S') -----------" >> logs/runonce/${DATETIME}-00_ALL.log
  fi
}


docker_restart () {
  clear
  startExec0000=$(date +'%s')
  openCD $0
  directory_cli=$PWD
  if [ -f "logs/startup.pid" ]; then
    rightH1 $YELLOW 'Restart containers' $WHITE '⟳' "."
    date +'%s' > logs/startup.pid
    cd DOCKER/
    docker compose restart
    clear
  else
      CUSTOM_RIGHT $NC 'Restart containers' $LIGHT_RED "The project has not started" $RED "✘" " " "✘" 0
  fi   
  timeExec=$(diffTime "$startExec0000")
  CUSTOM_RIGHT $WHITE "Done all:" $LIGHT_GRAY "$timeExec" $WHITE "✔" "." "✔" 0
  ln
  generate_version
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
  directory_cli=$PWD
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
      ln
      startup
      cd logs
      colorize $LIGHT_GREEN "✔ $LIGHT_RED$(rm -v startup.pid)"
  else
      CUSTOM_RIGHT $NC 'Stop & down all containers' $LIGHT_RED "The project has not started" $RED "✘" " " "✘" 0
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
    if [[ $directory_cli == *"/www"* ]]; then
      workdir=" -w ${directory_cli/$PWD/\/var}"
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