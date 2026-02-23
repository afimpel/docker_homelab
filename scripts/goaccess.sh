#!/bin/bash

############################################################
# goaccess                                                 #
############################################################

goaccess () {
    startExec0000=$(date +'%s')
    openCD $0
    unix=$(date '+%Y_%m_%d-%s')
    rightH1 $YELLOW 'GoAccess' $WHITE '☐' "."
    get_hostfiles
    echo "# goaccess Sites" > logs/goaccess/lists-serverData.log
    more hostsfile.conf | while read -r ip hostname extras; do
        datesss=$(date)
        echo -e "\n--- $ip --- $datesss ---" >> logs/goaccess/lists-serverData.log
        if [ "$ip" == "#" ]; then
            echo "" > /dev/null;
        elif [ ! -z "$hostname" ]; then
            colorize $LIGHT_GRAY "✔ $WHITE $hostname"
            sites_name="${hostname//./_}";
            echo "$hostname > $sites_name.out" >> logs/goaccess/lists-serverData.log
            # Si hay hostnames adicionales en la misma línea
            curl --http3 -silent "https://$hostname" -o "logs/goaccess/site-${sites_name}.out"
            write_message "GoAccess ➤ URL: https://$hostname" "goaccess" 
            for extra in $extras; do
                URLSnginx=$(echo "$extra" | cut -d "-" -f 1)
                URLSnginx0=$(echo "$extra" | cut -d "." -f 1)
                if [ "$URLSnginx0" == "www" ]; then
                    URLSnginx="nginx"
                fi
                if [ "$URLSnginx" != "nginx" ]; then
                    sites_name2="${extra//./_}";
                    write_message "GoAccess ➤ URL: https://$extra" "goaccess" 
                    curl --http3 -silent "https://$extra" -o "logs/goaccess/site-${sites_name}-${sites_name2}.out"
                    echo "$hostname > $extra > $sites_name2.out" >> logs/goaccess/lists-serverData.log
                fi
            done
        fi
    done
    echo -e "\n-------------------\n# docker\n" >> logs/goaccess/lists-serverData.log    
    docker stop homelab-goaccess 1>> logs/goaccess/lists-serverData.log 2>&1
    sleep 1s
    docker start homelab-goaccess 1>> logs/goaccess/lists-serverData.log 2>&1
    docker restart homelab-webserver 1>> logs/goaccess/lists-serverData.log 2>&1
    timeExec=$(diffTime "$startExec0000")
    CUSTOM_RIGHT $WHITE "GoAccess Done:" $LIGHT_GRAY "$timeExec" $WHITE "✔" "." "✔" 0
}

