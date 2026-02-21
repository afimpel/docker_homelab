#!/bin/bash
find . -path "*/storage/logs/*" ! -name '.gitignore' -exec chmod 777 {} -R \;
chmod -R 777 /var/log/php /var/log/sites-logs /var/log/supervisor