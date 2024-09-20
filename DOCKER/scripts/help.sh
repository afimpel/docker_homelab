#!/bin/bash

############################################################
# Help                                                     #
############################################################

help()
{
   # Display Help
   container_name="homelab-php7"
   R1 $YELLOW 'Help ' $WHITE '☐' "." 
   R1 $WHITE 'Syntax : ' $LIGTH_GREEN '✔' " " 
   echo -e "\t➤ ${LIGTH_GREEN}./homelab${NC} <cmd> <options>"
   echo -e ""
   R1 $WHITE 'Commands (cmd) : ' $LIGTH_GREEN '✔' " " 
   echo -e "\t➤ ${LIGTH_CYAN}install${NC}\t\t\t\tInstall this project"
   echo -e "\t➤ ${LIGTH_CYAN}help${NC}\t\t\t\t\tPrint this help"
   echo -e "\t➤ ${LIGTH_CYAN}up${NC}\t\t\t\t\tStart containers"
   if [ "$(docker ps -q -f name=$container_name)" ]; then
      php7=$(docker_bash "homelab-php7" "php" -v | head -1 | cut -d " " -f 2)
      php8=$(docker_bash "homelab-php8" "php" -v | head -1 | cut -d " " -f 2)
      echo -e "\t➤ ${LIGTH_CYAN}dumps${NC}\t\t\t\t\tbackup of all databases of all mariadb complete (excluding system db)"
      echo -e "\t➤ ${LIGTH_CYAN}ps${NC}\t\t\t\t\tPrint started containers"
      echo -e "\t➤ ${LIGTH_CYAN}down${NC}\t\t\t\t\tStop & down containers"
      echo -e "\t➤ ${LIGTH_CYAN}logs <container_name>${NC}\t\t\tDocker logs"
      echo -e ""
      echo -e "\t➤ ${LIGTH_CYAN}bash <container_name>${NC}\t\t\tDocker bash in container"
      echo -e "\t➤ ${LIGTH_CYAN}php7${NC}\t\t\t\t\tDocker bash in PHP $php7 ( ${RED}♚ root${NC} )"
      echo -e "\t➤ ${LIGTH_CYAN}php7-cli${NC}\t\t\t\tDocker CLI in PHP $php7 ( ${RED}♚ root${NC} )"
      echo -e "\t➤ ${LIGTH_CYAN}php7-usr${NC}\t\t\t\tDocker bash in PHP $php7 ( ${CYAN}♟ ${USERNAME}${NC} )"
      echo -e "\t➤ ${LIGTH_CYAN}php8${NC}\t\t\t\t\tDocker bash in PHP $php8 ( ${RED}♚ root${NC} )"
      echo -e "\t➤ ${LIGTH_CYAN}php8-cli${NC}\t\t\t\tDocker CLI in PHP $php8 ( ${RED}♚ root${NC} )"
      echo -e "\t➤ ${LIGTH_CYAN}php8-usr${NC}\t\t\t\tDocker bash in PHP $php8 ( ${CYAN}♟ ${USERNAME}${NC} )"
      echo -e "\t➤ ${LIGTH_CYAN}newsite <site> <type>${NC}\t\t\tCreate the New SubDomain ( ${GREEN}<site>.${COMPOSE_PROJECT_NAME,,}.local${NC} )"
      echo -e "\t\t\t\t\t\t${GREEN}<type>${NC} ( php7, php8 y build )"
      www
   fi
   echo -e ""
}
www()
{
   echo -e ""
   R1 $WHITE "WWW ( ${COMPOSE_PROJECT_NAME,,}.md ): " $LIGTH_GREEN '✔' " " 
   input_file="$(dirname $0)/${COMPOSE_PROJECT_NAME,,}.md"
   # Replace 'input_file.txt' with the name of your file

   # Read each line from the file
   # Read each line from the file
   while IFS= read -r line; do
      # Check for section titles
      if [[ $line =~ ^#\ (.*) ]]; then
         title="${BASH_REMATCH[1]}"
         echo -e "  ${LIGTH_GREEN}☐${NC} ${title}:"
      # Check for links with any format before the URL
      elif [[ ! -z  $line ]]; then
         url=$(echo "$line" |grep -Eo 'https://[^ )]+'|head -1)
         echo -e "\t➤ ${LIGTH_CYAN}$url${NC}"
      fi
   done < "$input_file"
}