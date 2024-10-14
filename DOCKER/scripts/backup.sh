#!/bin/bash

############################################################
# backup                                                   #
############################################################

backup () {
    openCD $0
    unix=$(date '+%Y_%m_%d-%s')
    R1 $WHITE "backup:" $LIGHT_GRAY "✔" "."
    clearLogs
    if [ -f "logs/startup.pid" ]; then
        R1 $GREEN "DUMPS: dumpSQL/database" $WHITE '✔' "."
        docker_bash "homelab-mariadb" "dump_databases"
    fi
    R1 $GREEN "FILES: backup" $WHITE '✔' "."
    echo "## mkcert install" > ${COMPOSE_PROJECT_NAME,,}_cert.md
    ls DOCKER/certs >> ${COMPOSE_PROJECT_NAME,,}_cert.md
    tar --exclude='*/node_modules/*' --exclude='*/vendor/*' --exclude='*/storage/framework/*' --exclude='*/.git/*' --exclude='*.log' --exclude='*.tgz' -cvzf backup/${unix}-${COMPOSE_PROJECT_NAME,,}_backup.tgz www/domains www/subdomains dumpSQL/database config DOCKER/.env ${COMPOSE_PROJECT_NAME,,}*.md /etc/hosts
    size=$(du -sh backup/${unix}-${COMPOSE_PROJECT_NAME,,}_backup.tgz | awk '{print $1}')
    CUSTOM_RIGHT $WHITE "backup Done:" $LIGHT_GRAY "${unix}-${COMPOSE_PROJECT_NAME,,}_backup.tgz ($size)" $WHITE "✔" "." "✔" 0
}

