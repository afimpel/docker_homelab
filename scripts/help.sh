#!/bin/bash

############################################################
# Help                                                     #
############################################################

help()
{
   # Display Help
   echo -e "Syntax: ${YELLOW}homelab <cmd> <options>${NC}"
   echo -e ""
   echo -e "options:"
   echo -e "\t${LIGTH_CYAN}-h${NC}\t\t\t\tPrint this help"
   echo -e ""
   echo -e "commands (cmd):"
   echo -e "\t${LIGTH_CYAN}help${NC}\t\t\t\tPrint this help"
   echo -e "\t${LIGTH_CYAN}up${NC}\t\t\t\tStart containers."
   echo -e "\t${LIGTH_CYAN}ps${NC}\t\t\t\tPrint started containers"
   echo -e "\t${LIGTH_CYAN}logs <container_name>${NC}\t\tDocker logs."
   echo -e "\t${LIGTH_CYAN}bash <container_name>${NC}\t\tDocker bash in container."
   echo -e "\t${LIGTH_CYAN}php7${NC}\t\t\t\tDocker bash in PHP7."
   echo -e "\t${LIGTH_CYAN}php8${NC}\t\t\t\tDocker bash in PHP8."
   echo -e "\t${LIGTH_CYAN}newsite <site> <type>${NC}\t\tCreate the New SubDomain."
   echo -e "\t\t\t\t\ttype ( php7, php8 y build )"
   echo -e "\t${LIGTH_CYAN}down${NC}\t\t\t\tStop & down containers."
   echo
}
