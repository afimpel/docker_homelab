#!/bin/bash

############################################################
# goaccess                                                 #
############################################################

goaccess () {
    startExec0000=$(date +'%s')
    openCD $0
    unix=$(date '+%Y_%m_%d-%s')
    rightH1 $YELLOW 'GoAccess' $WHITE '☐' "."
    more /etc/hosts | grep "${COMPOSE_PROJECT_NAME,,}"  | sort | uniq > hostsfile.conf
    echo "# goaccess Sites" > logs/goaccess/serverData-lists.log
    more hostsfile.conf | while read -r ip hostname extras; do
        if [ "$ip" == "#" ]; then
            echo;
        elif [ ! -z "$hostname" ]; then
            colorize $LIGHT_GRAY "✔ $WHITE $hostname"
            sites_name="${hostname//./_}";
            echo "$hostname > $sites_name.out" >> logs/goaccess/serverData-lists.log
            # Si hay hostnames adicionales en la misma línea
            curl -silent "https://$hostname" -o "logs/goaccess/site-$sites_name.out"
            for extra in $extras; do
                URLSnginx=$(echo "$extra" | cut -d "-" -f 1)
                if [ "$URLSnginx" != "nginx" ]; then
                    sites_name2="${extra//./_}";
                    curl -silent "https://$extra" -o "logs/goaccess/site-$sites_name2.out"
                    echo "$extra > $sites_name2.out" >> logs/goaccess/serverData-lists.log
                fi
            done
        fi
    done
    echo -e "\n# docker" >> logs/goaccess/serverData-lists.log    
    docker stop homelab-goaccess 1>> logs/goaccess/serverData-lists.log 2>&1
    sleep 1s
    docker start homelab-goaccess 1>> logs/goaccess/serverData-lists.log 2>&1
    docker restart homelab-webserver 1>> logs/goaccess/serverData-lists.log 2>&1
    timeExec=$(diffTime "$startExec0000")
    CUSTOM_RIGHT $WHITE "GoAccess Done:" $LIGHT_GRAY "$timeExec" $WHITE "✔" "." "✔" 0
}

