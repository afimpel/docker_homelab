#!/bin/bash

############################################################
# Help                                                     #
############################################################

help()
{
   php7=$(docker_bash "homelab-php7" "php" -v | head -1 | cut -d " " -f 2)
   php8=$(docker_bash "homelab-php8" "php" -v | head -1 | cut -d " " -f 2)
   # Display Help
   R1 $YELLOW 'Help ' $WHITE '☐' "." 
   echo -e ""
   echo -e "  ${LIGTH_GREEN}✔${NC} Syntax:\n\t${LIGTH_GREEN}./homelab${NC} <cmd> <options>"
   echo -e ""
   echo -e "  ${LIGTH_GREEN}✔${NC} commands (cmd):"
   echo -e "\t➤ ${LIGTH_CYAN}install${NC}\t\t\t\tInstall this project"
   echo -e "\t➤ ${LIGTH_CYAN}help${NC}\t\t\t\t\tPrint this help"
   echo -e "\t➤ ${LIGTH_CYAN}up${NC}\t\t\t\t\tStart containers"
   echo -e "\t➤ ${LIGTH_CYAN}dumps${NC}\t\t\t\t\tbackup of all databases of all mariadb complete (excluding system db)"
   echo -e "\t➤ ${LIGTH_CYAN}ps${NC}\t\t\t\t\tPrint started containers"
   echo -e "\t➤ ${LIGTH_CYAN}logs <container_name>${NC}\t\t\tDocker logs"
   echo -e "\t➤ ${LIGTH_CYAN}bash <container_name>${NC}\t\t\tDocker bash in container"
   echo -e "\t➤ ${LIGTH_CYAN}php7${NC}\t\t\t\t\tDocker bash in PHP $php7 (root)"
   echo -e "\t➤ ${LIGTH_CYAN}php7-cli${NC}\t\t\t\tDocker CLI in PHP $php7 (root)"
   echo -e "\t➤ ${LIGTH_CYAN}php7-usr${NC}\t\t\t\tDocker bash in PHP $php7 (${USERNAME})"
   echo -e "\t➤ ${LIGTH_CYAN}php8${NC}\t\t\t\t\tDocker bash in PHP $php8 (root)"
   echo -e "\t➤ ${LIGTH_CYAN}php8-cli${NC}\t\t\t\tDocker CLI in PHP $php8 (root)"
   echo -e "\t➤ ${LIGTH_CYAN}php8-usr${NC}\t\t\t\tDocker bash in PHP $php8 (${USERNAME})"
   echo -e "\t➤ ${LIGTH_CYAN}newsite <site> <type>${NC}\t\t\tCreate the New SubDomain ( ${GREEN}<site>.${COMPOSE_PROJECT_NAME,,}.local${NC} )"
   echo -e "\t\t\t\t\t\t${GREEN}<type>${NC} ( php7, php8 y build )"
   echo -e "\t➤ ${LIGTH_CYAN}down${NC}\t\t\t\t\tStop & down containers"
   echo
   echo -e "  ${LIGTH_GREEN}✔${NC} WWW:"
   echo -e "\t➤ ${LIGTH_CYAN}https://www.${COMPOSE_PROJECT_NAME,,}.local/${NC}"
   echo -e "\t➤ ${LIGTH_CYAN}https://adminer.${COMPOSE_PROJECT_NAME,,}.local/${NC}"
   echo -e "\t➤ ${LIGTH_CYAN}https://redis.${COMPOSE_PROJECT_NAME,,}.local/${NC}"
   echo -e "\t➤ ${LIGTH_CYAN}https://mailhog.${COMPOSE_PROJECT_NAME,,}.local/${NC}"
   echo -e ""
}
