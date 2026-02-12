#!/bin/bash

############################################################
# newsite                                                  #
############################################################

newsite()
{
   subcommand=${3,,}

   case "$subcommand" in
      php8)
         typefile="php8";
         subdir="public";
      ;;
      php7)
         typefile="php7";
         subdir="public";
      ;;
      build)
         typefile="build";
         subdir="build";
      ;;
      *)
         typefile="build";
         subdir="build";
      ;;
   esac
   subdomainsNAME=""
   sites=${2,,}
   subdomainsTrue=1;
   typefileFinal=${typefile}
   if [ "$1" == "0" ]; then
      subdomainsTrue=0;
      sites_url="${sites}.${COMPOSE_PROJECT_NAME,,}";
      sites_name="${sites}_${COMPOSE_PROJECT_NAME,,}";
   elif [ "$1" == "2" ]; then
      sites_url="${sites}";
      sites_name="${sites//./_}";
      typefileFinal="legacy-${typefile}";
      subdir="";
   elif [ "$1" == "3" ]; then
      subdomainsTrue=0;
      sites_url="${sites}.${COMPOSE_PROJECT_NAME,,}";
      sites_name="${sites}_${COMPOSE_PROJECT_NAME,,}";
      typefileFinal="legacy-${typefile}";
      subdir="";
   else
      sites_url="${sites}";
      sites_name="${sites//./_}";
   fi
   examplesiteDir="${sites_url}.local"

   if [[ $sites == *.* ]]; then
      subdomainsTrue=1;
      subdomains=$(echo "$sites_url" | cut -d "." -f 1);
      sites=$(echo "$sites_url" | cut -d "." -f 2);
      subdomainsNAME=" | ${subdomains^^}"
   fi


   exist 'mkcert'
   rightH1 $YELLOW "${typefileFinal^^} :: https://${sites_url}.local" $WHITE "⛁" "."
   ln
   openCD $0
   if [ ! -f "config/nginx-sites/${sites_name}_local-${typefileFinal}.conf" ]; then
      filename="_subdomains"
      cp -v DOCKER/examples/examplesite-${typefileFinal}-local.conf config/nginx-sites/${sites_name}_local-${typefileFinal}.conf
      sed -i "s/examplesiteDir/${examplesiteDir,,}/g" config/nginx-sites/${sites_name}_local-${typefileFinal}.conf
      if [ $subdomainsTrue == 0 ]; then
         siteFile="SubDomains"
         sed -i "s/examplesite/${sites}/g" config/nginx-sites/${sites_name}_local-${typefileFinal}.conf
         sed -i "s/COMPOSE_PROJECT_NAME/${COMPOSE_PROJECT_NAME,,}/g" config/nginx-sites/${sites_name}_local-${typefileFinal}.conf
      else
         filename="_domains"
         siteFile="Domains"
         sed -i "s/subdomains/domains/g" config/nginx-sites/${sites_name}_local-${typefileFinal}.conf
         sed -i "s/examplesite_COMPOSE_PROJECT_NAME/${sites_name}/g" config/nginx-sites/${sites_name}_local-${typefileFinal}.conf
         sed -i "s/examplesite.COMPOSE_PROJECT_NAME/${sites_url}/g" config/nginx-sites/${sites_name}_local-${typefileFinal}.conf
         sed -i "s/COMPOSE_PROJECT_NAME./gkgkgkgkgkgkgkgkgkgkgkgkgkgkgkgkgkgkgkgkgkgkggkgk/g" config/nginx-sites/${sites_name}_local-${typefileFinal}.conf
         sed -i "s/.gkgkgkgkgkgkgkgkgkgkgkgkgkgkgkgkgkgkgkgkgkgkggkgk././g" config/nginx-sites/${sites_name}_local-${typefileFinal}.conf
         sed -i "s/examplesite/${sites_url}/g" config/nginx-sites/${sites_name}_local-${typefileFinal}.conf
      fi
      if [ ! -d "www/${siteFile,,}/${examplesiteDir,,}/${subdir,,}" ]; then
         mkdir -p www/${siteFile,,}/${examplesiteDir,,}/${subdir,,}
         indexFile="index.php"
         if [ "$typefile" == "php8" ]; then
            cp -v DOCKER/examples/php-newsite.php www/${siteFile,,}/${examplesiteDir}/${subdir,,}/index.php
         elif [ "$typefile" == "php7" ]; then
            cp -v DOCKER/examples/php-newsite.php www/${siteFile,,}/${examplesiteDir}/${subdir,,}/index.php
         else
            indexFile="index.html"
            cp -v DOCKER/examples/legacy-newsite.html www/${siteFile,,}/${examplesiteDir}/${subdir,,}/index.html
         fi
         datesSite=$(date '+%Y-%m-%d %X')
         sed -i "s/datesSite/${datesSite}/g" www/${siteFile,,}/${examplesiteDir}/${subdir,,}/$indexFile
         sed -i "s/wwwSite/${sites_url}/g" www/${siteFile,,}/${examplesiteDir}/${subdir,,}/$indexFile
         sed -i "s/typeSite/${siteFile}/g" www/${siteFile,,}/${examplesiteDir}/${subdir,,}/$indexFile
         sed -i "s/COMPOSE_PROJECT_NAME/${COMPOSE_PROJECT_NAME,,}/g" www/${siteFile,,}/${examplesiteDir}/${subdir,,}/$indexFile
         sed -i "s/COMPOSE_PROJECT_NAME/${COMPOSE_PROJECT_NAME,,}/g" www/${siteFile,,}/${examplesiteDir}/${subdir,,}/$indexFile
      fi
      
      
      sudo bash -c "echo -e '127.0.1.1\t\t${sites_url}.local www.${sites_url}.local nginx-${sites_name}-${COMPOSE_PROJECT_NAME,,}.local' >> /etc/hosts"

      dateTime=$(date '+%Y_%m_%d-%s')
      echo -e "${sites_url}.local www.${sites_url}.local;${sites_name}_local;${sites_url};${sites_name}_local-${typefileFinal};certs_${sites_name,,}_local;${dateTime};new" >> mkcert_homelab.csv
      cd DOCKER/certs

      mkcert ${sites_url}.local www.${sites_url}.local
      mv -v ${sites_url}.local*-key.pem certs_${sites_name}_local-key.pem 
      mv -v ${sites_url}.local*.pem certs_${sites_name}_local.pem 

      openCD $0
      more config/nginx-sites/${sites_name}_local-${typefileFinal}.conf | grep server_name | head -1
      if [ ! -f "${COMPOSE_PROJECT_NAME,,}${filename}.md" ]; then
         echo -e "# ${siteFile}\n" > "${COMPOSE_PROJECT_NAME,,}${filename}.md"
      fi
      echo -e "* [${sites^^}${subdomainsNAME}](https://${sites_url}.local) :: ${typefileFinal^^}" >> "${COMPOSE_PROJECT_NAME,,}${filename}.md"
      { head -n 2 ${COMPOSE_PROJECT_NAME,,}${filename}.md; tail -n +3 ${COMPOSE_PROJECT_NAME,,}${filename}.md | sort; } > ${COMPOSE_PROJECT_NAME,,}${filename}.md.tmp && mv ${COMPOSE_PROJECT_NAME,,}${filename}.md.tmp ${COMPOSE_PROJECT_NAME,,}${filename}.md
      docker restart homelab-webserver
      ln
      mkcert -install
      if [ -x "$(command -v notify-send)" ]; then
         startup=$(cat logs/startup.pid)
         startupDate=$(diffTime "$startup")
         /usr/bin/notify-send "Compose use: ${COMPOSE_PROJECT_NAME^^}" "The website ${sites_url}.local and Restarted Webserver" -a "HomeLab" -i dialog-information -t 8000 1>/dev/null 2>&1
      fi
      leftH1 $LIGHT_CYAN " done ... (${sites_url}.local)" $WHITE "⛁" "."
   else
      leftH1 $LIGHT_CYAN " The website already exists ... (${sites_url}.local)" $WHITE "⛁" "."
   fi
   ln
   www
}

delsite()
{
   subdomainsTrue=1;
   filename="_domains"
   sites=${2,,}
   if [ "$1" == "0" ]; then
      subdomainsTrue=0;
      filename="_subdomains"
      sites_url="${sites}.${COMPOSE_PROJECT_NAME,,}";
      sites_name="${sites}_${COMPOSE_PROJECT_NAME,,}";
   elif [ "$1" == "2" ]; then
      sites_url="${sites}";
      sites_name="${sites//./_}";
   else
      sites_url="${sites}";
      sites_name="${sites//./_}";
   fi
   deleteDir=${3,,}
   if [ ! -z "$4" ]; then
      filename="_domains"
      subdomainsTrue=1;
      sites_url="${4,,}.${sites}";
      sites_name="${4,,}_${sites}";
   fi      

   if [ -f config/nginx-sites/${sites_name}_local-*.conf ]; then
      rightH1 $LIGHT_RED "DELETE :: https://${sites_url}.local" $WHITE "⛁" "."  
      mv -v ${COMPOSE_PROJECT_NAME,,}${filename}.md ${COMPOSE_PROJECT_NAME,,}${filename}_bk.md
      grep -v "${sites_url}.local" /etc/hosts > logs/hostsfile.log 
      sudo bash -c "mv -v logs/hostsfile.log /etc/hosts"
      cp -v mkcert_homelab.csv mkcert_preDelete.csv
      grep -v "${sites_url}.local" ${COMPOSE_PROJECT_NAME,,}${filename}_bk.md > ${COMPOSE_PROJECT_NAME,,}${filename}.md
      { head -n 2 ${COMPOSE_PROJECT_NAME,,}${filename}.md; tail -n +3 ${COMPOSE_PROJECT_NAME,,}${filename}.md | sort; } > ${COMPOSE_PROJECT_NAME,,}${filename}.md.tmp && mv ${COMPOSE_PROJECT_NAME,,}${filename}.md.tmp ${COMPOSE_PROJECT_NAME,,}${filename}.md
      grep -v "certs_${sites_name}_local" mkcert_preDelete.csv > mkcert_homelab.csv
      rm ${COMPOSE_PROJECT_NAME,,}${filename}_bk.md 
      rm -v config/nginx-sites/${sites_name}_local-*.conf
      rm -v DOCKER/certs/certs_${sites_name}_local*
      if [ "$deleteDir" == "yes" ]; then
         ln
         if [ "$subdomainsTrue" == "0" ]; then
            rm -vrf www/subdomains/${sites_url}.local
         else
            rm -vrf www/domains/${sites_url}.local
         fi
      fi
      if [ -x "$(command -v notify-send)" ]; then
         startup=$(cat logs/startup.pid)
         startupDate=$(diffTime "$startup")
         /usr/bin/notify-send "Compose use: ${COMPOSE_PROJECT_NAME^^}" "The website ${sites_url}.local was deleted and Restarted Webserver" -a "HomeLab" -i dialog-information -t 8000 1>/dev/null 2>&1
      fi
      docker restart homelab-webserver
   else
      leftH1 $LIGHT_CYAN " The website not exists ... (${sites_url}.local)" $WHITE "⛁" "."
   fi
   ln
   www
}



www()
{
   openCD $0
   rightH1 $YELLOW "WWW ( ${COMPOSE_PROJECT_NAME,,}.md )" $WHITE '✔' "." 
   write_message "WWW ( ${COMPOSE_PROJECT_NAME,,} ) ✔" "website" 
   input_file="$(dirname $0)/${COMPOSE_PROJECT_NAME,,}.md"
   lnline=0
   first=1
   echo "{\"datetime\":\"$(date)\",\"items\":[" > TEMP/algo0.json
   while IFS= read -r line0; do
      # Check for section titles
      if [[ $line0 =~ ^#\ (.*) ]]; then
         if [[ $lnline == 1 ]]; then
            ln
         fi
         lnline=1
         title="${BASH_REMATCH[1]}"
         rightH1 $NC "${title}:" $LIGHT_GREEN '☐' " "
      elif [[ ! -z  $line0 ]]; then
         url=$(echo "$line0" |grep -Eo 'https://[^ )]+'|head -1)
         write_message "${COMPOSE_PROJECT_NAME,,} ➤ URL: $url" "website" 
         echo -e "\t➤ ${LIGHT_CYAN}$url${NC}"
         if [[ $first == 0 ]]; then
            echo "," >> TEMP/algo0.json
         fi
         first=0
         regex='\[([^]]+)\]\(([^)]+)\) :: (.+)$'
         if [[ $line0 =~ $regex ]]; then
            title="${BASH_REMATCH[1]}"
            url="${BASH_REMATCH[2]}"
            type="${BASH_REMATCH[3]}"
            echo "{\"title\": \"${title}\", \"url\": \"${url}\", \"type\": \"${type,,}\"}" >> TEMP/algo0.json
         fi
      fi
   done < "$input_file"
   echo "]}" >> TEMP/algo0.json
   jq . TEMP/algo0.json > www/dash/home.json
   lengthContent=$(jq '.items | length' www/dash/home.json)
   write_message "${COMPOSE_PROJECT_NAME,,} ➤ length: $lengthContent\n " "website" 

   input_file0="$(dirname $0)/${COMPOSE_PROJECT_NAME,,}_domains.md"
   echo "{\"datetime\":\"$(date)\",\"items\":[" > TEMP/algo1.json
   if [ -f "${input_file0}" ]; then
      ln
      rightH1 $YELLOW "Domains ( ${COMPOSE_PROJECT_NAME,,}_domains.md )" $WHITE '✔' "." 
      lnline=0
      first=1
      while IFS= read -r line1; do
         # Check for section titles
         if [[ $line1 =~ ^#\ (.*) ]]; then
            if [[ $lnline == 1 ]]; then
               ln
            fi
            lnline=1
            title="${BASH_REMATCH[1]}"
            rightH1 $NC "${title}:" $LIGHT_GREEN '☐' " "
         elif [[ ! -z  $line1 ]]; then
            url=$(echo "$line1" |grep -Eo 'https://[^ )]+'|head -1)
            echo -e "\t➤ ${LIGHT_CYAN}$url${NC}"
            if [[ $first == 0 ]]; then
               echo "," >> TEMP/algo1.json
            fi
            first=0
            regex='\[([^]]+)\]\(([^)]+)\) :: (.+)$'
            if [[ $line1 =~ $regex ]]; then
               title="${BASH_REMATCH[1]}"
               url="${BASH_REMATCH[2]}"
               type="${BASH_REMATCH[3]}"
               urlType2=$(echo "${url}" | sed 's/https\?:\/\///' | sed 's/\/$//' | cut -d'.' -f1)
               if [[ $urlType2 == *api* ]] || [[ $urlType2 == *json* ]]; then
                  urlType="api"
               else
                  urlType="www"
               fi
               haystack=$DOMAINS_EXCLUDE
               needle="$urlType2"
               if [[ "$haystack" == *",$needle,"* ]]; then
                  exclude_domains=true
               else
                  exclude_domains=false
               fi
               write_message "domains ➤ URL: $url / needle: $needle / exclude: $haystack / type: $urlType / $exclude_domains" "website" 
               echo "{\"title\": \"${title}\", \"url\": \"${url}\", \"type\": \"${type,,}\", \"urlType\":\"${urlType,,}\", \"exclude\":${exclude_domains,,} }" >> TEMP/algo1.json
            fi
         fi
      done < "$input_file0"
   fi
   echo "]}" >> TEMP/algo1.json
   jq . TEMP/algo1.json > www/dash/domains.json
   lengthContent=$(jq '.items | length' www/dash/domains.json)
   write_message "domains ➤ length: $lengthContent\n " "website" 
   if [ $lengthContent -eq 0 ]; then
      if [ -f "${input_file0}" ]; then
         rm -v $input_file0
      fi
   fi

   input_file1="$(dirname $0)/${COMPOSE_PROJECT_NAME,,}_subdomains.md"
   echo "{\"datetime\":\"$(date)\",\"items\":[" > TEMP/algo2.json
   if [ -f "${input_file1}" ]; then
      ln
      rightH1 $YELLOW "SubDomains ( ${COMPOSE_PROJECT_NAME,,}_subdomains.md )" $WHITE '✔' "." 
      lnline=0
      first=1
      while IFS= read -r line2; do
         # Check for section titles
         if [[ $line2 =~ ^#\ (.*) ]]; then
            if [[ $lnline == 1 ]]; then
               ln
            fi
            lnline=1
            title="${BASH_REMATCH[1]}"
            rightH1 $NC "${title}:" $LIGHT_GREEN '☐' " "
         elif [[ ! -z  $line2 ]]; then
            if [[ $first == 0 ]]; then
               echo "," >> TEMP/algo2.json
            fi
            first=0
            url=$(echo "$line2" |grep -Eo 'https://[^ )]+'|head -1)
            echo -e "\t➤ ${LIGHT_CYAN}$url${NC}"
            regex='\[([^]]+)\]\(([^)]+)\) :: (.+)$'
            if [[ $line2 =~ $regex ]]; then
               title="${BASH_REMATCH[1]}"
               url="${BASH_REMATCH[2]}"
               type="${BASH_REMATCH[3]}"
               urlType2=$(echo "${url}" | sed 's/https\?:\/\///' | sed 's/\/$//' | cut -d'.' -f1)
               if [[ $urlType2 == *api* ]] || [[ $urlType2 == *json* ]]; then
                  urlType="api"
               else
                  urlType="www"
               fi
               haystack=$SUBDOMAINS_EXCLUDE
               needle=",$urlType2,"
               if [[ "$haystack" == *",$needle,"* ]]; then
                  exclude_domains=true
               else
                  exclude_domains=false
               fi
               write_message "subdomains ➤ URL: $url / needle: $needle / exclude: $haystack / type: $urlType / $exclude_domains" "website" 
               echo "{\"title\": \"${title}\", \"url\": \"${url}\", \"type\": \"${type,,}\", \"urlType\":\"${urlType,,}\", \"exclude\":${exclude_domains,,} }" >> TEMP/algo2.json
            fi
         fi
      done < "$input_file1"
  fi
  echo "]}" >> TEMP/algo2.json
  jq . TEMP/algo2.json > www/dash/subdomains.json

  lengthContent=$(jq '.items | length' www/dash/subdomains.json)
  write_message "subdomains ➤ length: $lengthContent\n " "website" 
  write_message "DELETE: \n$(rm -fv TEMP/*.json)\n\n\t---\t\t $(date) \t\t---" "website" 
  if [ $lengthContent -eq 0 ]; then
      if [ -f "${input_file1}" ]; then
         rm -v $input_file1
      fi
  fi

}