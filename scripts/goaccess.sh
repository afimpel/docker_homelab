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
    datesss=$(date)
    echo -e "[ 0\t ] GoAccess Sites \t --- $datesss ---" > logs/goaccess/lists-serverData.log
    datesss=$(date)
    echo -e "\n[ 0\t ] \tDelete\t\t\t --- $datesss ---" >> logs/goaccess/lists-serverData.log
    find logs/goaccess \( -type f -name "*.out" \) -delete -printf "[ 🗑  ]\tREMOVED:\t\t  %p\n" | sort >> logs/goaccess/lists-serverData.log 2>&1
    echo -e "\n[ 0\t ] \tSitios\t\t\t --- $datesss ---" >> logs/goaccess/lists-serverData.log
    cat TEMP/hostsfile_domains.conf >> logs/goaccess/lists-serverData.log
    counter00=-1
    more TEMP/hostsfile_domains.conf | while read -r ip hostname extras; do
        counter=0
        counter00=$(( counter00 + 1 )) 
        datesss=$(date)
        if [ "$ip" == "#" ]; then
            echo "" > /dev/null;
        elif [ ! -z "$hostname" ]; then
            sites_name="${hostname//./_}";
            touch logs/goaccess/site-${counter00}-${sites_name}-000-int.out
            echo -e "\n[ $counter00\t ] \t$ip\t\t--- $datesss --- https://$hostname ---" >> logs/goaccess/lists-serverData.log
            colorize $LIGHT_GREEN "✔ $WHITE $hostname"
            # Si hay hostnames adicionales en la misma línea
            echo -e "URL:\t https://$hostname " > logs/goaccess/site-${counter00}-${sites_name}-000.out
            curl --http3 -H 'Accept: application/json' -silent "https://$hostname" -o "logs/goaccess/site-${counter00}-${sites_name}-000-int.out"
            sleep 1s
            cat logs/goaccess/site-${counter00}-${sites_name}-000-int.out >> logs/goaccess/site-${counter00}-${sites_name}-000.out
            sizeOUT=$(du -h logs/goaccess/site-${counter00}-${sites_name}-000.out)
            echo -e "[info] \thttps://$hostname ➤ $sizeOUT" >> logs/goaccess/lists-serverData.log
            echo -e "\n\n[SIZE] $sizeOUT" >> logs/goaccess/site-${counter00}-${sites_name}-000.out
            write_message "GoAccess ➤ URL: https://$hostname" "goaccess"
            for extra in $extras; do
                URLSnginx=$(echo "$extra" | cut -d "-" -f 1)
                URLSnginx0=$(echo "$extra" | cut -d "." -f 1)
                if [ "$URLSnginx0" == "www" ]; then
                    URLSnginx="nginx"
                fi
                if [ "$hostname" == "$extra" ]; then
                    URLSnginx="nginx"
                fi
                if [ "$URLSnginx" != "nginx" ]; then
                    counter=$(( counter + 1 )) 
                    sites_name2="${extra//./_}";
                    write_message "GoAccess ➤ URL: https://$extra" "goaccess" 
                    echo -e "URL:\t https://$extra " > logs/goaccess/site-${counter00}-${sites_name}-${counter}00-${sites_name2}.out
                    curl --http3 -H 'Accept: application/json' -silent "https://$extra" -o "logs/goaccess/site-${counter00}-${sites_name}-${counter}00-${sites_name2}-int.out"
                    sleep 1s
                    cat logs/goaccess/site-${counter00}-${sites_name}-${counter}00-${sites_name2}-int.out >> logs/goaccess/site-${counter00}-${sites_name}-${counter}00-${sites_name2}.out
                    sizeOUT=$(du -h logs/goaccess/site-${counter00}-${sites_name}-${counter}00-$sites_name2.out)
                    echo -e "[info] \thttps://$hostname | https://$extra ➤ $sizeOUT" >> logs/goaccess/lists-serverData.log
                    echo -e "\n\n[SIZE] $sizeOUT" >> logs/goaccess/site-${counter00}-${sites_name}-${counter}00-$sites_name2.out
                fi
            done
        fi
    done
    sleep 4s
    datesss=$(date)
    echo -e "\n[ 99 ] \tDelete\t\t\t --- $datesss ---" >> logs/goaccess/lists-serverData.log
    find logs/goaccess \( -type f -name "*int.out" \) -delete -printf "[ 🗑  ]\tREMOVED:\t\t  %p\n" | sort >> logs/goaccess/lists-serverData.log 2>&1
    ###rm -v logs/goaccess/site-*-int.out >> logs/goaccess/lists-serverData.log 2>&1
    sleep 2s
    datesss=$(date)
    echo -e "\n[ 99 ] Docker stop\t\t --- $datesss ---" >> logs/goaccess/lists-serverData.log
    docker stop homelab-goaccess 1>> logs/goaccess/lists-serverData.log 2>&1
    sleep 1s
    datesss=$(date)
    echo -e "\n[ 99 ] Docker start\t\t --- $datesss ---" >> logs/goaccess/lists-serverData.log
    docker start homelab-goaccess 1>> logs/goaccess/lists-serverData.log 2>&1
    docker restart homelab-redisinsight 1>> logs/goaccess/lists-serverData.log 2>&1
    docker restart homelab-mailer 1>> logs/goaccess/lists-serverData.log 2>&1
    docker restart homelab-webserver 1>> logs/goaccess/lists-serverData.log 2>&1
    echo " "
    datesss=$(date)
    timeExec=$(diffTime "$startExec0000")
    echo -e "\n[ 99 ] DONE:\t\t$timeExec\t --- $datesss ---" >> logs/goaccess/lists-serverData.log
    CUSTOM_RIGHT $WHITE "GoAccess Done:" $LIGHT_GRAY "$timeExec" $WHITE "✔" "." "✔" 0
}

