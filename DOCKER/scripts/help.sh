#!/bin/bash

############################################################
# Help                                                     #
############################################################

help()
{
   # Display Help
   R1 $YELLOW 'Help ' $WHITE '☐' "." 
   echo -e " ${LIGTH_GREEN}✔${NC} Syntax:\n\t${LIGTH_GREEN}./homelab${NC} <cmd> <options>"
   echo -e ""
   echo -e " ${LIGTH_GREEN}✔${NC} commands (cmd):"
   echo -e "\t${LIGTH_CYAN}install${NC}\t\t\t\tinstall project"
   echo -e "\t${LIGTH_CYAN}help${NC}\t\t\t\tPrint this help"
   echo -e "\t${LIGTH_CYAN}up${NC}\t\t\t\tStart containers."
   echo -e "\t${LIGTH_CYAN}dumps${NC}\t\t\t\tbackup of all databases of all mariadb complete (excluding system db)"
   echo -e "\t${LIGTH_CYAN}ps${NC}\t\t\t\tPrint started containers"
   echo -e "\t${LIGTH_CYAN}logs <container_name>${NC}\t\tDocker logs."
   echo -e "\t${LIGTH_CYAN}bash <container_name>${NC}\t\tDocker bash in container."
   echo -e "\t${LIGTH_CYAN}php7${NC}\t\t\t\tDocker bash in PHP7. (root)"
   echo -e "\t${LIGTH_CYAN}php8${NC}\t\t\t\tDocker bash in PHP8. (root)"
   echo -e "\t${LIGTH_CYAN}php7-usr${NC}\t\t\tDocker bash in PHP7. (${USERNAME})"
   echo -e "\t${LIGTH_CYAN}php8-usr${NC}\t\t\tDocker bash in PHP8. (${USERNAME})"
   echo -e "\t${LIGTH_CYAN}newsite <site> <type>${NC}\t\tCreate the New SubDomain."
   echo -e "\t\t\t\t\ttype ( php7, php8 y build )"
   echo -e "\t${LIGTH_CYAN}down${NC}\t\t\t\tStop & down containers."
   echo
   echo -e " ${LIGTH_GREEN}✔${NC} WWW:\n\t${LIGTH_CYAN}Https://www.${COMPOSE_PROJECT_NAME,,}.local/${NC}\n"

}
