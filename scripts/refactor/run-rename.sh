#!/usr/bin/env bash
openCD $0
if [ -d "www/domains" ]; then
    for configFiles in config/nginx-sites/*.conf ; do
        DATETIME="$(date +%Y%m%d)"
        if [ -r "$configFiles" ] ; then
            nombre_archivo=$(basename "${configFiles}")
            CUSTOM_LEFT $NC "$nombre_archivo" $BLUE "$DATETIME" $LIGHT_GREEN "➤" " " "⏲" 7
            sed -i 's|/var/log/nginx/\(domains\|subdomains\)|/var/log/nginx/sites|g' $configFiles
            sed -i 's|/var/www/\(domains\|subdomains\)|/var/www|g' $configFiles
            sed -i 's|/var/www/dash|/var/www-dash|g' $configFiles
        fi
    done
    CUSTOM_LEFT $NC "Move: domains" $BLUE "$DATETIME" $LIGHT_GREEN "➤" " " "⏲" 7
    cd www
    mv -rvf domains/* .
    cd ..
fi
if [ -d "www/subdomains" ]; then
    CUSTOM_LEFT $NC "Move: subdomains" $BLUE "$DATETIME" $LIGHT_GREEN "➤" " " "⏲" 7
    cd www
    mv -rvf subdomains/* .
    cd ..
fi

CUSTOM_LEFT $NC "Done ... " $BLUE "$DATETIME" $LIGHT_GREEN "➤" " " "⏲" 7