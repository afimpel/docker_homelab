#!/bin/bash

############################################################
# recreate-ssl                                             #
############################################################

recreate-ssl()
{
   openCD $0
   cd DOCKER/certs
   rm -v *.pem
   openCD $0
   echo -e "MKCERT\n" > logs/mkcert.log
   rm mkcert_recreate.csv
   touch mkcert_recreate.csv
   rightH1 $YELLOW "SSL Certificate Recreation" $LIGHT_GREEN '✔' "." 
   exist 'mkcert'
   input_file="mkcert.csv"
   lnline=0
   while IFS= read -r line; do
      dateTimeFormat=$(date '+%s')
      dateTime=$(date '+%Y-%m-%d')
      URLS=$(echo "$line" | cut -d ";" -f 1)
      file=$(echo "$line" | cut -d ";" -f 2)
      domain=$(echo "$line" | cut -d ";" -f 3)
      fileConf=$(echo "$line" | cut -d ";" -f 4)
      fileSSL=$(echo "$line" | cut -d ";" -f 5)
      fileSSLcert="certs_${file}_${dateTimeFormat}"
      echo -e "\t --- https://${domain}.local --- " >> logs/mkcert.log
      echo -e "✔ URLS: \t\t\t $URLS" >> logs/mkcert.log
      echo -e "✔ file: \t\t\t $file" >> logs/mkcert.log
      echo -e "✔ domain: \t\t\t $domain" >> logs/mkcert.log
      echo -e "✔ fileConf: \t\t config/nginx-sites/${fileConf}.conf" >> logs/mkcert.log
      echo -e "✔ fileSSL: \t\t\t $fileSSL" >> logs/mkcert.log
      echo -e "✔ fileSSLcert: \t\t $fileSSLcert" >> logs/mkcert.log
      echo -e "\t --- --- --- ---" >> logs/mkcert.log
      ln
      rightH1 $LIGHT_PURPLE "${domain,,,}.local" $LIGHT_GREEN '⛁' "."
      cd DOCKER/certs
      mkcert ${URLS,,}
      mv -v ${domain,,}.local*-key.pem ${fileSSLcert,,}-key.pem 
      mv -v ${domain,,}.local*.pem ${fileSSLcert,,}.pem 
      openCD $0
      cat "config/nginx-sites/${fileConf}.conf" | grep "${fileSSL}" >> logs/mkcert.log
      sed -i "s/${fileSSL,,}/${fileSSLcert,,}/g" config/nginx-sites/${fileConf}.conf
      echo -e "\t --- --- --- --- \n" >> logs/mkcert.log
      echo -e "${URLS};${file};${domain};${fileConf};${fileSSLcert};${dateTime};recreate" >> mkcert_recreate.csv
      leftH1 $LIGHT_CYAN " done ... (https://${domain}.local)" $WHITE "✔" "."
   done < "$input_file"
   ln
   docker restart homelab-webserver
   mkcert -install
   mv -v mkcert_recreate.csv mkcert.csv
   leftH1 $LIGHT_GREEN 'DONE' $WHITE '✔' "."
}