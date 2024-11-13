#!/bin/bash

############################################################
# backup                                                   #
############################################################

backup () {
    startExec0000=$(date +'%s')
    openCD $0
    unix=$(date '+%Y_%m_%d-%s')
    CUSTOM_RIGHT $GREEN "Backup:" $WHITE "$OLDPWD/backup" $WHITE "✔" "." "✔" 0
    find . -name "*.tgz" -mtime -15 -exec rm {} \;
    #clearLogs
    if [ -f "logs/startup.pid" ]; then
        ln
        dumpsdb
    fi
    ln
    CUSTOM_RIGHT $LIGHT_GRAY "FILES:" $WHITE "$OLDPWD" $WHITE "✔" "_" "✔" 0
    more /etc/hosts | grep "${COMPOSE_PROJECT_NAME,,}"  | sort | uniq > hostsfile.conf
    tar --exclude='*/node_modules/*' --exclude='*/vendor/*' --exclude='*/storage/framework/*' --exclude='*/.git/logs/*' --exclude='*/.git/objects/*' --exclude='*.log' --exclude='*.tgz' -cvzf backup/${unix}-${COMPOSE_PROJECT_NAME,,}_backup.tgz www/domains www/subdomains dumpSQL/*/*.sql config DOCKER/.env ${COMPOSE_PROJECT_NAME,,}*.md hostsfile.conf mkcert.csv > logs/backups.log
    lines=$(wc -l logs/backups.log | cut -d " " -f 1)
    echo " ✔  Compressed files: $lines."
    size=$(du -sh backup/${unix}-${COMPOSE_PROJECT_NAME,,}_backup.tgz | awk '{print $1}')
    echo -e "\n ${unix}-${COMPOSE_PROJECT_NAME,,}_backup.tgz ($size)" >> logs/backups.log
    echo " 🗃  ${unix}-${COMPOSE_PROJECT_NAME,,}_backup.tgz ($size)"
    ln
 
    timeExec=$(diffTime "$startExec0000")
    CUSTOM_RIGHT $WHITE "backup Done:" $LIGHT_GRAY "$timeExec" $WHITE "✔" "." "✔" 0
}

