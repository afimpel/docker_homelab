#!/bin/bash

############################################################
# newsite                                                  #
############################################################

newsite()
{
   sites=${1,,}

   subcommand=${2,,}

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

   R1 $YELLOW "${typefile^^} :: https://${sites}.${COMPOSE_PROJECT_NAME,,}.local" $WHITE "⛁" "."
   ln
   if [ ! -f "config/nginx-sites/${typefile}-${sites}_${COMPOSE_PROJECT_NAME,,}_local.conf" ]; then

      mkdir -p www/sites/${sites}/${subdir}
      mkcert -install

      cp -v DOCKER/examples/examplesite-${typefile}-local.conf config/nginx-sites/${typefile}-${sites}_${COMPOSE_PROJECT_NAME,,}_local.conf
      sed -i "s/examplesite/${sites}/g" config/nginx-sites/${typefile}-${sites}_${COMPOSE_PROJECT_NAME,,}_local.conf
      sed -i "s/COMPOSE_PROJECT_NAME/${COMPOSE_PROJECT_NAME,,}/g" config/nginx-sites/${typefile}-${sites}_${COMPOSE_PROJECT_NAME,,}_local.conf

      echo -e "127.0.0.1\t\t${sites}.${COMPOSE_PROJECT_NAME,,}.local www.${sites}.${COMPOSE_PROJECT_NAME,,}.local" | sudo tee -a /etc/hosts

      cd DOCKER/certs

      mkcert ${sites}.${COMPOSE_PROJECT_NAME,,}.local www.${sites}.${COMPOSE_PROJECT_NAME,,}.local
      mv -v ${sites}.${COMPOSE_PROJECT_NAME,,}.local*-key.pem certs_${sites}_${COMPOSE_PROJECT_NAME,,}_local-key.pem 
      mv -v ${sites}.${COMPOSE_PROJECT_NAME,,}.local*.pem certs_${sites}_${COMPOSE_PROJECT_NAME,,}_local.pem 

      cd ../..
      more config/nginx-sites/${typefile}-${sites}_${COMPOSE_PROJECT_NAME,,}_local.conf | grep server_name | head -1
      if [ ! -f "${COMPOSE_PROJECT_NAME,,}.md" ]; then
         echo "# SITIOS " > ${COMPOSE_PROJECT_NAME,,}.md
      fi
      echo -e " *  [${sites^^}](https://${sites}.${COMPOSE_PROJECT_NAME,,}.local) :: ${typefile^^}" >> ${COMPOSE_PROJECT_NAME,,}.md
      docker restart homelab-webserver
      ln
      L1 $LIGTH_CYAN " done ... (${sites}.${COMPOSE_PROJECT_NAME,,}.local)" $WHITE "⛁" "."
   else
      L1 $LIGTH_CYAN " The website already exists ... (${sites}.${COMPOSE_PROJECT_NAME,,}.local)" $WHITE "⛁" "."
   fi
}

www()
{
   R1 $YELLOW "WWW ( ${COMPOSE_PROJECT_NAME,,}.md )" $LIGTH_GREEN '✔' "." 
   input_file="$(dirname $0)/${COMPOSE_PROJECT_NAME,,}.md"

   while IFS= read -r line; do
      # Check for section titles
      if [[ $line =~ ^#\ (.*) ]]; then
         title="${BASH_REMATCH[1]}"
         echo -e "  ${LIGTH_GREEN}☐${NC} ${title}:"
      elif [[ ! -z  $line ]]; then
         url=$(echo "$line" |grep -Eo 'https://[^ )]+'|head -1)
         echo -e "\t➤ ${LIGTH_CYAN}$url${NC}"
      fi
   done < "$input_file"
   ln
}