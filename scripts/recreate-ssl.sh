#!/bin/bash

############################################################
# recreate-ssl                                             #
############################################################

recreate-ssl()
{
   openCD $0
   echo -e "MKCERT\n" > logs/mkcert.log
   echo -e "\n\t --- Recreating SSL Certificates ---\n" >> logs/mkcert.log
   rightH1 $YELLOW "SSL Certificate Recreation" $LIGHT_GREEN '✔' "." 
   exist 'mkcert'
   input_file="mkcert_homelab.csv"
   if [ -z $1 ]; then
      echo -e "\t --- Using default input file: mkcert_homelab.csv --- \n" >> logs/mkcert.log
      sudo rm -v DOCKER/certs/*.pem >> logs/mkcert.log
      touch mkcert_recreate.csv
      rm -v mkcert_recreate.csv >> logs/mkcert.log
   else
      input_file=$(grep -i "$1" mkcert_homelab.csv)
   fi
   lnline=0
   dateTimeFormat=$(date '+%s')
   while IFS= read -r line; do
      dateTime=$(date '+%Y-%m-%d')
      URLS=$(echo "$line" | cut -d ";" -f 1)
      file=$(echo "$line" | cut -d ";" -f 2 | sed 's/\./_/g')
      domain=$(echo "$line" | cut -d ";" -f 3)
      fileConf=$(echo "$line" | cut -d ";" -f 4 | sed 's/\./_/g')
      fileSSL=$(echo "$line" | cut -d ";" -f 5 | sed 's/\./_/g')
      fileSSLcert="certs_${file}_${dateTimeFormat}"
      echo -e "\t --- https://${domain}.local --- " >> logs/mkcert.log
      echo -e "✔ URLS: \t\t\t $URLS" >> logs/mkcert.log
      echo -e "✔ file: \t\t\t $file" >> logs/mkcert.log
      echo -e "✔ domain: \t\t\t $domain" >> logs/mkcert.log
      echo -e "✔ fileConf: \t\t config/nginx-sites/${fileConf}.conf" >> logs/mkcert.log
      echo -e "✔ fileSSL_IN: \t\t $fileSSL" >> logs/mkcert.log
      echo -e "✔ fileSSL_OUT: \t\t $fileSSLcert" >> logs/mkcert.log
      echo -e "\t --- --- --- ---" >> logs/mkcert.log
      ln
      rightH1 $LIGHT_PURPLE "${domain,,,}.local" $LIGHT_GREEN '⛁' "."
      sudo cp -v $HOME/.local/share/mkcert/rootCA* DOCKER/certs/mkcert >> logs/mkcert.log
      cd DOCKER/certs
      mkcert ${URLS,,}
      mv -v ${domain,,}.local*-key.pem ${fileSSLcert,,}-key.pem >>../../logs/mkcert.log
      mv -v ${domain,,}.local*.pem ${fileSSLcert,,}.pem >>../../logs/mkcert.log
      openCD $0
      sed -i "s/${fileSSL,,}/${fileSSLcert,,}/g" config/nginx-sites/${fileConf}.conf
      cat "config/nginx-sites/${fileConf}.conf" | grep "${fileSSL}" >> logs/mkcert.log
      echo -e "\t --- --- --- --- \n" >> logs/mkcert.log
      if [ -z $1 ]; then
         echo -e "${URLS};${file};${domain};${fileConf};${fileSSLcert};${dateTime};recreate" >> mkcert_recreate.csv
         sleep 2
      fi
      leftH1 $LIGHT_CYAN " done ... (https://${domain}.local)" $WHITE "✔" "."
   done < "$input_file"
   ln
   docker restart homelab-webserver
   mkcert -install >> logs/mkcert.log
   if [ -z $1 ]; then
      mv -v mkcert_recreate.csv mkcert_homelab.csv >> logs/mkcert.log
   fi
   leftH1 $LIGHT_GREEN 'DONE' $WHITE '✔' "."
}