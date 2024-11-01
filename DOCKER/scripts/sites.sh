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

   sites=${2,,}
   if [ "$1" == "0" ]; then
      sites_url="${sites}.${COMPOSE_PROJECT_NAME,,}";
      sites_name="${sites}_${COMPOSE_PROJECT_NAME,,}";
   elif [ "$1" == "2" ]; then
      sites_url="${sites}";
      sites_name="${sites//./_}";
      typefile="legacy-${typefile}";
      subdir="";
   else
      sites_url="${sites}";
      sites_name="${sites//./_}";
   fi

   exist 'mkcert'
   rightH1 $YELLOW "${typefile^^} :: https://${sites_url}.local" $WHITE "⛁" "."
   ln
   openCD $0
   if [ ! -f "config/nginx-sites/${typefile}-${sites_name}_local.conf" ]; then
      filename="_subdomains"
      cp -v DOCKER/examples/examplesite-${typefile}-local.conf config/nginx-sites/${typefile}-${sites_name}_local.conf
      if [ "$1" == "0" ]; then
         siteFile="SubDomains"
         mkdir -p www/subdomains/${sites}/${subdir}
         sed -i "s/examplesite/${sites}/g" config/nginx-sites/${typefile}-${sites_name}_local.conf
         sed -i "s/COMPOSE_PROJECT_NAME/${COMPOSE_PROJECT_NAME,,}/g" config/nginx-sites/${typefile}-${sites_name}_local.conf
      else
         filename="_domains"
         siteFile="Domains"
         mkdir -p www/domains/${sites}/${subdir}
         sed -i "s/subdomains/domains/g" config/nginx-sites/${typefile}-${sites_name}_local.conf
         sed -i "s/examplesite_COMPOSE_PROJECT_NAME/${sites_name}/g" config/nginx-sites/${typefile}-${sites_name}_local.conf
         sed -i "s/examplesite.COMPOSE_PROJECT_NAME/${sites_url}/g" config/nginx-sites/${typefile}-${sites_name}_local.conf
         sed -i "s/COMPOSE_PROJECT_NAME./gkgkgkgkgkgkgkgkgkgkgkgkgkgkgkgkgkgkgkgkgkgkggkgk/g" config/nginx-sites/${typefile}-${sites_name}_local.conf
         sed -i "s/.gkgkgkgkgkgkgkgkgkgkgkgkgkgkgkgkgkgkgkgkgkgkggkgk././g" config/nginx-sites/${typefile}-${sites_name}_local.conf
         sed -i "s/examplesite/${sites_url}/g" config/nginx-sites/${typefile}-${sites_name}_local.conf
      fi
      sudo bash -c "echo -e '127.0.0.1\t\t${sites_url}.local www.${sites_url}.local nginx-${sites}-${COMPOSE_PROJECT_NAME,,}.local' >> /etc/hosts"

      dateTime=$(date '+%Y_%m_%d-%s')
      echo -e "${sites_url}.local www.${sites_url}.local;${sites_name}_local;${sites_url};${typefile}-${sites_name}_local;certs_${sites_name,,}_local;${dateTime};new" >> mkcert.csv
      cd DOCKER/certs

      mkcert ${sites_url}.local www.${sites_url}.local
      mv -v ${sites_url}.local*-key.pem certs_${sites_name}_local-key.pem 
      mv -v ${sites_url}.local*.pem certs_${sites_name}_local.pem 

      openCD $0
      more config/nginx-sites/${typefile}-${sites_name}_local.conf | grep server_name | head -1
      if [ ! -f "${COMPOSE_PROJECT_NAME,,}${filename}.md" ]; then
         echo -e "# ${siteFile}\n" > "${COMPOSE_PROJECT_NAME,,}${filename}.md"
      fi
      echo -e "* [${sites^^}](https://${sites_url}.local) :: ${typefile^^}" >> "${COMPOSE_PROJECT_NAME,,}${filename}.md"
      docker restart homelab-webserver
      ln
      mkcert -install
      leftH1 $LIGHT_CYAN " done ... (${sites_url}.local)" $WHITE "⛁" "."
   else
      leftH1 $LIGHT_CYAN " The website already exists ... (${sites_url}.local)" $WHITE "⛁" "."
   fi
}

delsite()
{
   filename="_domains"
   sites=${2,,}
   if [ "$1" == "0" ]; then
      filename="_subdomains"
      sites_url="${sites}.${COMPOSE_PROJECT_NAME,,}";
      sites_name="${sites}_${COMPOSE_PROJECT_NAME,,}";
   elif [ "$1" == "2" ]; then
      sites_url="${sites}";
      sites_name="${sites//./_}";
      subdir="";
   else
      sites_url="${sites}";
      sites_name="${sites//./_}";
   fi
   deleteDir=${3,,}
   if [ -f "config/nginx-sites/*-${sites_name}_local.conf" ]; then
      rightH1 $LIGHT_RED "DELETE :: https://${sites_url}.local" $WHITE "⛁" "."  
      mv -v ${COMPOSE_PROJECT_NAME,,}${filename}.md ${COMPOSE_PROJECT_NAME,,}${filename}_bk.md
      cp -v mkcert.csv mkcert_preDelete.csv
      grep -v "${sites_url}.local" ${COMPOSE_PROJECT_NAME,,}${filename}_bk.md > ${COMPOSE_PROJECT_NAME,,}${filename}.md
      grep -v "certs_${sites_name}_local" mkcert_preDelete.csv > mkcert.csv
      rm ${COMPOSE_PROJECT_NAME,,}${filename}_bk.md 
      rm -v config/nginx-sites/*-${sites_name}_local.conf
      rm -v DOCKER/certs/certs_${sites_name}_local*
      if [ "$deleteDir" == "yes" ]; then
         ln
         if [ "$1" == "0" ]; then
            rm -vrf www/subdomains/${sites}
         else
            rm -vrf www/domains/${sites}
         fi
      fi
      docker restart homelab-webserver
   else
      leftH1 $LIGHT_CYAN " The website not exists ... (${sites_url}.local)" $WHITE "⛁" "."
   fi
}



www()
{
   openCD $0
   rightH1 $YELLOW "WWW ( ${COMPOSE_PROJECT_NAME,,}.md )" $LIGHT_GREEN '✔' "." 
   input_file="${COMPOSE_PROJECT_NAME,,}.md"
   lnline=0
   while IFS= read -r line; do
      # Check for section titles
      if [[ $line =~ ^#\ (.*) ]]; then
         if [[ $lnline == 1 ]]; then
            ln
         fi
         lnline=1
         title="${BASH_REMATCH[1]}"
         rightH1 $NC "${title}:" $LIGHT_GREEN '☐' " "
      elif [[ ! -z  $line ]]; then
         url=$(echo "$line" |grep -Eo 'https://[^ )]+'|head -1)
         echo -e "\t➤ ${LIGHT_CYAN}$url${NC}"
      fi
   done < "$input_file"

   input_file0="${COMPOSE_PROJECT_NAME,,}_domains.md"
   if [ -f "${input_file0}" ]; then
      ln
      rightH1 $YELLOW "Domains ( ${COMPOSE_PROJECT_NAME,,}_domains.md )" $LIGHT_GREEN '✔' "." 
      lnline=0
      while IFS= read -r line; do
         # Check for section titles
         if [[ $line =~ ^#\ (.*) ]]; then
            if [[ $lnline == 1 ]]; then
               ln
            fi
            lnline=1
            title="${BASH_REMATCH[1]}"
            rightH1 $NC "${title}:" $LIGHT_GREEN '☐' " "
         elif [[ ! -z  $line ]]; then
            url=$(echo "$line" |grep -Eo 'https://[^ )]+'|head -1)
            echo -e "\t➤ ${LIGHT_CYAN}$url${NC}"
         fi
      done < "$input_file0"
   fi

   input_file0="$(dirname $0)/${COMPOSE_PROJECT_NAME,,}_subdomains.md"
   if [ -f "${input_file0}" ]; then
      ln
      rightH1 $YELLOW "SubDomains ( ${COMPOSE_PROJECT_NAME,,}_subdomains.md )" $LIGHT_GREEN '✔' "." 
      lnline=0
      while IFS= read -r line; do
         # Check for section titles
         if [[ $line =~ ^#\ (.*) ]]; then
            if [[ $lnline == 1 ]]; then
               ln
            fi
            lnline=1
            title="${BASH_REMATCH[1]}"
            rightH1 $NC "${title}:" $LIGHT_GREEN '☐' " "
         elif [[ ! -z  $line ]]; then
            url=$(echo "$line" |grep -Eo 'https://[^ )]+'|head -1)
            echo -e "\t➤ ${LIGHT_CYAN}$url${NC}"
         fi
      done < "$input_file0"
   fi
}