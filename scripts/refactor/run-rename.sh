#!/usr/bin/env bash

cd $(dirname $0)/../../
pwd
if [ -d "www/domains" ]; then
    for configFiles in config/nginx-sites/*.conf ; do
        DATETIME="$(date +%Y%m%d)"
        if [ -r "$configFiles" ] ; then
            nombre_archivo=$(basename "${configFiles}")
            echo -e "➤\t $nombre_archivo\t\t\t⏲ $(date '+%Y-%m-%d %H:%M:%S')\n"
            sed -i 's|/var/log/nginx/\(domains\|subdomains\)|/var/log/nginx/sites|g' $configFiles
            sed -i 's|/var/www/\(domains\|subdomains\)|/var/www|g' $configFiles
            sed -i 's|/var/www/dash|/var/www-dash|g' $configFiles
        fi
    done
    echo -e "➤\t Move: domains\t\t\t⏲ $(date '+%Y-%m-%d %H:%M:%S')\n"
    cd www
    mv -vf domains/* .
    cd ..
fi
if [ -d "www/subdomains" ]; then
    echo -e "➤\t Move: domains\t\t\t⏲ $(date '+%Y-%m-%d %H:%M:%S')\n"
    cd www
    mv -vf subdomains/* .
    cd ..
fi
