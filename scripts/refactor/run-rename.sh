#!/usr/bin/env bash

cd $(dirname $0)/../../
pwd
if [ -d "www/domains" ]; then
    for configFiles in config/supervisor/*/*.conf ; do
        DATETIME="$(date +%Y%m%d)"
        if [ -r "$configFiles" ] ; then
            nombre_archivo=$(basename "${configFiles}")
            echo -e "➤\t Supervisor \t $nombre_archivo\t\t\t⏲ $(date '+%Y-%m-%d %H:%M:%S')\n"
            sed -i 's|/var/www/domains|/var/www|g; s|/var/www/subdomains|/var/www|g' $configFiles
        fi
    done

    for configFiles in config/nginx-sites/*.conf ; do
        DATETIME="$(date +%Y%m%d)"
        if [ -r "$configFiles" ] ; then
            nombre_archivo=$(basename "${configFiles}")
            echo -e "➤\t Nginx \t $nombre_archivo\t\t\t⏲ $(date '+%Y-%m-%d %H:%M:%S')\n"
            sed -i 's|/var/log/nginx/domains|/var/log/nginx/sites|g; s|/var/log/nginx/subdomains|/var/log/nginx/sites|g' $configFiles
            sed -i 's|/var/www/domains|/var/www|g; s|/var/www/subdomains|/var/www|g' $configFiles
            sed -i 's|/var/www/dash|/var/www-dash|g' $configFiles
        fi
    done
    echo -e "➤\t Move: \t domains\t\t\t⏲ $(date '+%Y-%m-%d %H:%M:%S')\n"
    cd www
    mv -vf domains/* .
    rm -vr domains
    cd ..
fi
if [ -d "www/subdomains" ]; then
    echo -e "➤\t Move: domains\t\t\t⏲ $(date '+%Y-%m-%d %H:%M:%S')\n"
    cd www
    mv -vf subdomains/* .
    rm -vr subdomains
    cd ..
fi
if [ -d "www/dash" ]; then
    rm -vr www/dash
fi
