#!/bin/bash

############################################################
# recreate-ssl                                             #
############################################################

recreate-ssl()
{
   openCD $0
   rm mkcert_recreate.csv
   touch mkcert_recreate.csv
   rightH1 $YELLOW "SSL Certificate Recreation" $LIGHT_GREEN '✔' "." 
   exist 'mkcert'
   input_file="mkcert.csv"
   lnline=0
   while IFS= read -r line; do
      URLS=$(echo "$line" | cut -d ";" -f 1)
      file=$(echo "$line" | cut -d ";" -f 2)
      domain=$(echo "$line" | cut -d ";" -f 3)
      ln
      rightH1 $LIGHT_PURPLE "${domain}.local" $LIGHT_GREEN '⛁' "."
      cd DOCKER/certs
      mkcert ${URLS}
      mv -v ${domain}.local*-key.pem certs_${file}-key.pem 
      mv -v ${domain}.local*.pem certs_${file}.pem 
      openCD $0
      dateTime=$(date '+%Y_%m_%d-%s')
      echo -e "${URLS};${file};${domain};${dateTime};recreate" >> mkcert_recreate.csv
      leftH1 $LIGHT_CYAN " done ... (https://${domain}.local)" $WHITE "✔" "."
   done < "$input_file"
   ln
   docker restart homelab-webserver
   mkcert -install
   mv -v mkcert_recreate.csv mkcert.csv
   leftH1 $LIGHT_GREEN 'DONE' $WHITE '✔' "."
}