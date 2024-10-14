#!/bin/bash

############################################################
# Help                                                     #
############################################################

help()
{
   # Display Help
   openCD $0
   R1 $YELLOW 'Help ' $WHITE '☐' "." 
   R1 $WHITE 'Syntax : ' $LIGHT_GREEN '✔' " " 
   echo -e "\t➤ ${LIGHT_GREEN}./homelab${NC} <cmd> <options>"
   echo -e ""
   R1 $WHITE 'Commands (cmd) : ' $LIGHT_GREEN '✔' " " 
   echo -e "\t➤ ${LIGHT_CYAN}help${NC}\t\t\t\t\tDisplay usage information. (this message)"
   if ! [ -f "${COMPOSE_PROJECT_NAME,,}.md" ]; then
      echo -e "\t➤ ${LIGHT_CYAN}install${NC}\t\t\t\tInstall this project."
   else
      if [ -f "logs/startup.pid" ]; then
         php7=$(docker_bash "homelab-php7" "php" -v | head -1 | cut -d " " -f 2)
         php8=$(docker_bash "homelab-php8" "php" -v | head -1 | cut -d " " -f 2)
         composer7=$(docker_bash "homelab-php7" "composer" -V | head -1 | cut -d " " -f 3)
         composer8=$(docker_bash "homelab-php8" "composer" -V | head -1 | cut -d " " -f 3)
         echo -e ""
         CUSTOM_LEFT $NC "Docker :" $LIGHT_GRAY " " $LIGHT_CYAN "☑" " " " " 4
         echo -e "\t➤ ${LIGHT_CYAN}ps${NC}\t\t\t\t\tPrint started containers."
         echo -e "\t➤ ${LIGHT_CYAN}restart${NC}\t\t\t\tRestart containers."
         echo -e "\t➤ ${LIGHT_CYAN}clear ${NC}\t\t\t\tClear all logs & Restart containers."
         echo -e "\t➤ ${LIGHT_CYAN}logs  ${NC}\t\t\t\tDocker All logs."
         echo -e "\t➤ ${LIGHT_CYAN}logs <container_name>${NC}\t\t\tDocker logs in container."
         echo -e "\t➤ ${LIGHT_CYAN}down${NC}\t\t\t\t\tStop & Down containers."
         echo -e "\t➤ ${LIGHT_CYAN}down clear${NC}\t\t\t\tStop, Down containers & Clear all logs."
         echo -e ""
         CUSTOM_LEFT $NC "BackUP :" $LIGHT_GRAY " " $LIGHT_CYAN "☑" " " " " 4
         echo -e "\t➤ ${LIGHT_CYAN}backup ${NC}\t\t\t\tbackup of files (www/DB/Configs)."
         echo -e "\t➤ ${LIGHT_CYAN}dumps${NC}\t\t\t\t\tPerform a full backup of all mariadb databases. (excluding system db)"
         echo -e "\t➤ ${LIGHT_CYAN}dumps <database_name>${NC}\t\t\tPerform a backup of a specified entire mariadb database."
         echo -e "\t➤ ${LIGHT_CYAN}import <database_name> <file>${NC}\t\tPerform a file import of a specific full mariadb database."
         echo -e ""
         CUSTOM_LEFT $NC "Docker Container :" $LIGHT_GRAY " " $LIGHT_CYAN "☑" " " " " 4
         echo -e "\t➤ ${LIGHT_CYAN}bash <container_name>${NC}\t\t\tDocker bash in container."
         echo -e "\t➤ ${LIGHT_CYAN}php7${NC}\t\t\t\t\tDocker bash in\t ${YELLOW}PHP $php7${NC}\t\t\t( ${RED}♚ root${NC} )"
         echo -e "\t➤ ${LIGHT_CYAN}php7-cli${NC}\t\t\t\tDocker CLI in\t ${YELLOW}PHP $php7${NC}\t\t\t( ${RED}♚ root${NC} )"
         echo -e "\t➤ ${LIGHT_CYAN}php7-composer${NC}\t\t\t\tDocker CLI in\t ${YELLOW}PHP $php7${NC} ➤ ${YELLOW}Composer $composer7${NC}\t( ${RED}♚ root${NC} )"
         echo -e "\t➤ ${LIGHT_CYAN}php7-usr${NC}\t\t\t\tDocker bash in\t ${YELLOW}PHP $php7${NC}\t\t\t( ${LIGHT_ORANGE}♟ ${USERNAME}${NC} )"
         echo -e "\t➤ ${LIGHT_CYAN}php8${NC}\t\t\t\t\tDocker bash in\t ${YELLOW}PHP $php8${NC}\t\t\t( ${RED}♚ root${NC} )"
         echo -e "\t➤ ${LIGHT_CYAN}php8-cli${NC}\t\t\t\tDocker CLI in\t ${YELLOW}PHP $php8${NC}\t\t\t( ${RED}♚ root${NC} )"
         echo -e "\t➤ ${LIGHT_CYAN}php8-composer${NC}\t\t\t\tDocker CLI in\t ${YELLOW}PHP $php8${NC} ➤ ${YELLOW}Composer $composer8${NC}\t( ${RED}♚ root${NC} )"
         echo -e "\t➤ ${LIGHT_CYAN}php8-usr${NC}\t\t\t\tDocker bash in\t ${YELLOW}PHP $php8${NC}\t\t\t( ${LIGHT_ORANGE}♟ ${USERNAME}${NC} )"
         echo -e ""
         CUSTOM_LEFT $NC "Sites :" $LIGHT_GRAY " " $LIGHT_CYAN "☑" " " " " 4
         echo -e "\t➤ ${LIGHT_CYAN}listsite ${NC}\t\t\t\tList all Sites."
         echo -e "\t➤ ${LIGHT_CYAN}newdomain <site> <type>${NC}\t\tCreate the New Domain. ( ${GREEN}<site>.local${NC} )"
         echo -e "\t\t\t\t\t\t${GREEN}<type>${NC} ( ${CYAN}build${NC}, ${CYAN}php7${NC} & ${CYAN}php8${NC} )"
         echo -e "\t➤ ${LIGHT_CYAN}newsudomain <site> <type>${NC}\t\tCreate the New SubDomain. ( ${GREEN}<site>.${COMPOSE_PROJECT_NAME,,}.local${NC} )"
         echo -e "\t\t\t\t\t\t${GREEN}<type>${NC} ( ${CYAN}build${NC}, ${CYAN}php7${NC} & ${CYAN}php8${NC} )"
      else
         echo -e ""
         CUSTOM_LEFT $NC "Docker :" $LIGHT_GRAY " " $LIGHT_CYAN "☑" " " " " 4
         echo -e "\t➤ ${LIGHT_CYAN}up${NC}\t\t\t\t\tStart containers."
      fi
   fi
}