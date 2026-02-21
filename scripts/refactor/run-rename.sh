#!/usr/bin/env bash
source $(dirname $0)/../utils.sh

openCD $0
if [ -d "www/domains" ]; then
    for configFiles in config/nginx-sites/*.conf ; do
        DATETIME="$(date +%Y%m%d)"
        if [ -r "$configFiles" ] ; then
            nombre_archivo=$(basename "${configFiles}")
            echo -e "➤\t $nombre_archivo\t\t\t⏲ $(date '+%Y-%m-%d %H:%M:%S')\n"
            CUSTOM_LEFT $NC "$nombre_archivo" $BLUE "$DATETIME" $LIGHT_GREEN "➤" " " "⏲" 7
            sed -i 's|/var/log/nginx/\(domains\|subdomains\)|/var/log/nginx/sites|g' $configFiles
            sed -i 's|/var/www/\(domains\|subdomains\)|/var/www|g' $configFiles
            sed -i 's|/var/www/dash|/var/www-dash|g' $configFiles
        fi
    done
    echo -e "➤\t Move: domains\t\t\t⏲ $(date '+%Y-%m-%d %H:%M:%S')\n"
    cd www
    mv -rvf domains/* .
    cd ..
fi
if [ -d "www/subdomains" ]; then
    echo -e "➤\t Move: domains\t\t\t⏲ $(date '+%Y-%m-%d %H:%M:%S')\n"
    cd www
    mv -rvf subdomains/* .
    cd ..
fi

echo -e "➤\t Done ...\t\t\t\t⏲ $(date '+%Y-%m-%d %H:%M:%S')\n"