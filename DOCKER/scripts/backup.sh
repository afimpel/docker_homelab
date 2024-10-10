#!/bin/bash

############################################################
# backup                                                   #
############################################################

backup () {
    cd $(dirname $0)/
    unix=$(date '+%Y_%m_%d-%s')
    R1 $WHITE "backup:" $LIGHT_GRAY "✔" "."
    if [ -f "logs/startup.pid" ]; then
        R1 $GREEN "DUMPS: $(dirname $0)/dumpSQL/database" $WHITE '✔' "."
        docker_bash "homelab-mariadb" "dump_databases"
    fi
    R1 $GREEN "FILES: $(dirname $0)/backup" $WHITE '✔' "."
    echo "## mkcert install" > ${COMPOSE_PROJECT_NAME,,}_cert.md
    ls DOCKER/certs >> ${COMPOSE_PROJECT_NAME,,}_cert.md
    tar --exclude='*/node_modules/*' --exclude='*/vendor/*' --exclude='*/package-lock.lock' --exclude='*.log' --exclude='*.tgz' -cvzf backup/${unix}-${COMPOSE_PROJECT_NAME,,}_backup.tgz www/domains www/subdomains dumpSQL/database config DOCKER/.env ${COMPOSE_PROJECT_NAME,,}*.md /etc/hosts
    size=$(du -sh backup/${unix}-${COMPOSE_PROJECT_NAME,,}_backup.tgz | awk '{print $1}')
    CUSTOM $WHITE "backup Done:" $LIGHT_GRAY "${unix}-${COMPOSE_PROJECT_NAME,,}_backup.tgz ($size)" $WHITE "✔" "." "✔" 0
}

