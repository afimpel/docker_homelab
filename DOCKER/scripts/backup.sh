#!/bin/bash

############################################################
# backup                                                   #
############################################################

backup () {
    openCD $0
    unix=$(date '+%Y_%m_%d-%s')
    rightH1 $WHITE "backup:" $LIGHT_GRAY "✔" "."
    clearLogs
    if [ -f "logs/startup.pid" ]; then
        rightH1 $GREEN "DUMPS: dumpSQL/database" $WHITE '✔' "."
        docker_bash "homelab-mariadb" "dump_databases"
    fi
    rightH1 $GREEN "FILES: backup" $WHITE '✔' "."
    more /etc/hosts | grep "${COMPOSE_PROJECT_NAME,,}" > hostsfile.conf
    tar --exclude='*/node_modules/*' --exclude='*/vendor/*' --exclude='*/storage/framework/*' --exclude='*/.git/logs/*' --exclude='*/.git/objects/*' --exclude='*.log' --exclude='*.tgz' -cvzf backup/${unix}-${COMPOSE_PROJECT_NAME,,}_backup.tgz www/domains www/subdomains dumpSQL/database config DOCKER/.env ${COMPOSE_PROJECT_NAME,,}*.md hostsfile.conf mkcert.csv
    size=$(du -sh backup/${unix}-${COMPOSE_PROJECT_NAME,,}_backup.tgz | awk '{print $1}')
    CUSTOM_RIGHT $WHITE "backup Done:" $LIGHT_GRAY "${unix}-${COMPOSE_PROJECT_NAME,,}_backup.tgz ($size)" $WHITE "✔" "." "✔" 0
}

