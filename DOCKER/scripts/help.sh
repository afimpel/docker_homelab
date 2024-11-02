#!/bin/bash

############################################################
# Help                                                     #
############################################################

help()
{
   # Display Help
   openCD $0
   rightH1 $YELLOW 'Help ' $WHITE '☐' "." 
   rightH1 $WHITE 'Syntax : ' $LIGHT_GREEN '✔' " " 
   echo -e "\t➤ ${LIGHT_GREEN}./homelab${NC} <cmd> <options>"
   echo -e ""
   rightH1 $WHITE 'Commands (cmd) : ' $LIGHT_GREEN '✔' " " 
   CUSTOM_CENTER $LIGHT_CYAN "help" $NC "Display usage information. (this message)" $NC "➤" " " " " "7+152"
   if ! [ -f "${COMPOSE_PROJECT_NAME,,}.md" ]; then
      CUSTOM_CENTER $LIGHT_CYAN "install" $NC "Install this project." $NC "➤" " " " " "7+152"
   else
      if [ -f "logs/startup.pid" ]; then
         php7=$(docker_bash "homelab-php7" "php" -v | head -1 | cut -d " " -f 2)
         php8=$(docker_bash "homelab-php8" "php" -v | head -1 | cut -d " " -f 2)
         composer7=$(docker_bash "homelab-php7" "composer" -V | head -1 | cut -d " " -f 3)
         composer8=$(docker_bash "homelab-php8" "composer" -V | head -1 | cut -d " " -f 3)
         echo -e ""
         CUSTOM_LEFT $NC "Docker :" $LIGHT_GRAY " " $LIGHT_CYAN "☑" " " " " 4
         CUSTOM_CENTER $LIGHT_CYAN "ps" $NC "Print started containers." $NC "➤" " " " " "7+152"
         CUSTOM_CENTER $LIGHT_CYAN "restart" $NC "Restart containers." $NC "➤" " " " " "7+152"
         CUSTOM_CENTER $LIGHT_CYAN "clear" $NC "Clear all logs & Restart containers." $NC "➤" " " " " "7+152"
         CUSTOM_CENTER $LIGHT_CYAN "logs" $NC "Docker All logs." $NC "➤" " " " " "7+152"
         CUSTOM_CENTER $LIGHT_CYAN "logs <container_name>" $NC "Docker logs in container." $NC "➤" " " " " "7+152"
         CUSTOM_CENTER $LIGHT_CYAN "down" $NC "Stop & Down containers." $NC "➤" " " " " "7+152"
         CUSTOM_CENTER $LIGHT_CYAN "down clear" $NC "Stop, Down containers & Clear all logs." $NC "➤" " " " " "7+152"
         echo -e ""
         CUSTOM_LEFT $NC "BackUP :" $LIGHT_GRAY " " $LIGHT_CYAN "☑" " " " " 4
         CUSTOM_CENTER $LIGHT_CYAN "backup" $NC "backup of files (www/DB/Configs)" $NC "➤" " " " " "7+152"
         CUSTOM_CENTER $LIGHT_CYAN "dumps" $NC "Perform a full backup of all mariadb databases. (excluding system db)" $NC "➤" " " " " "7+152"
         CUSTOM_CENTER $LIGHT_CYAN "dumps <database_name>" $NC "Perform a backup of a specified entire mariadb database." $NC "➤" " " " " "7+152"
         CUSTOM_CENTER $LIGHT_CYAN "import <database_name> <file>" $NC "Perform a file import of a specific full mariadb database." $NC "➤" " " " " "7+152"
         echo -e ""
         CUSTOM_LEFT $NC "Docker Container :" $LIGHT_GRAY " " $LIGHT_CYAN "☑" " " " " 4
         CUSTOM_CENTER $LIGHT_CYAN "bash <container_name>" $NC "Docker bash in container." $NC "➤" " " " " "7+152"

         CUSTOM_CENTER $LIGHT_CYAN "php7-usr" $NC "Docker bash in\t ${YELLOW}PHP $php7${NC}\t\t\t( ${LIGHT_ORANGE}♟ ${USERNAME}${NC} )" $NC "➤" " " " " "7+152"
         CUSTOM_CENTER $LIGHT_CYAN "php7" $NC "Docker bash in\t ${YELLOW}PHP $php7${NC}\t\t\t( ${RED}♚ root${NC} )" $NC "➤" " " " " "7+152"
         CUSTOM_CENTER $LIGHT_CYAN "php7-cli <command>" $NC "Docker CLI in\t ${YELLOW}PHP $php7${NC}\t\t\t( ${RED}♚ root${NC} )" $NC "➤" " " " " "7+152"
         CUSTOM_CENTER $LIGHT_CYAN "php7-composer <command>" $NC "Docker CLI in\t ${YELLOW}PHP $php7${NC} ➤ ${YELLOW}Composer $composer7${NC}\t( ${RED}♚ root${NC} )" $NC "➤" " " " " "7+152"
         
         CUSTOM_CENTER $LIGHT_CYAN "php8-usr" $NC "Docker bash in\t ${YELLOW}PHP $php8${NC}\t\t\t( ${LIGHT_ORANGE}♟ ${USERNAME}${NC} )" $NC "➤" " " " " "7+152"
         CUSTOM_CENTER $LIGHT_CYAN "php8" $NC "Docker bash in\t ${YELLOW}PHP $php8${NC}\t\t\t( ${RED}♚ root${NC} )" $NC "➤" " " " " "7+152"
         CUSTOM_CENTER $LIGHT_CYAN "php8-cli <command>" $NC "Docker CLI in\t ${YELLOW}PHP $php8${NC}\t\t\t( ${RED}♚ root${NC} )" $NC "➤" " " " " "7+152"
         CUSTOM_CENTER $LIGHT_CYAN "php8-composer <command>" $NC "Docker CLI in\t ${YELLOW}PHP $php8${NC} ➤ ${YELLOW}Composer $composer8${NC}\t( ${RED}♚ root${NC} )" $NC "➤" " " " " "7+152"
         
         echo -e ""
         CUSTOM_LEFT $NC "Sites :" $LIGHT_GRAY " " $LIGHT_CYAN "☑" " " " " 4
         CUSTOM_CENTER $LIGHT_CYAN "listsite" $NC "List all Sites." $NC "➤" " " " " "7+152"

         CUSTOM_CENTER $LIGHT_CYAN "recreate-ssl" $NC "Recreating SSL Certificates." $NC "➤" " " " " "7+152"

         CUSTOM_CENTER $LIGHT_CYAN "legacydomain <site> <type>" $NC "Create the New Domain. (Legacy Code) ( ${GREEN}<site>.local${NC} )" $NC "➤" " " " " "7+152"
         CUSTOM_CENTER $LIGHT_CYAN " " $NC "${GREEN}<type>${NC} ( ${CYAN}build${NC}, ${CYAN}php7${NC} & ${CYAN}php8${NC} )" $NC " " " " " " "7+152"

         CUSTOM_CENTER $LIGHT_CYAN "legacysubdomain <site> <type>" $NC "Create the New SubDomain. (Legacy Code) ( ${GREEN}<site>.${COMPOSE_PROJECT_NAME,,}.local${NC} )" $NC "➤" " " " " "7+152"
         CUSTOM_CENTER $LIGHT_CYAN " " $NC "${GREEN}<type>${NC} ( ${CYAN}build${NC}, ${CYAN}php7${NC} & ${CYAN}php8${NC} )" $NC " " " " " " "7+152"

         CUSTOM_CENTER $LIGHT_CYAN "newdomain <site> <type>" $NC "Create the New Domain. (Framework Code) ( ${GREEN}<site>.local${NC} )" $NC "➤" " " " " "7+152"
         CUSTOM_CENTER $LIGHT_CYAN " " $NC "${GREEN}<type>${NC} ( ${CYAN}build${NC}, ${CYAN}php7${NC} & ${CYAN}php8${NC} )" $NC " " " " " " "7+152"

         CUSTOM_CENTER $LIGHT_CYAN "newsubdomain <site> <type>" $NC "Create the New SubDomain. (Framework Code) ( ${GREEN}<site>.${COMPOSE_PROJECT_NAME,,}.local${NC} )" $NC "➤" " " " " "7+152"
         CUSTOM_CENTER $LIGHT_CYAN " " $NC "${GREEN}<type>${NC} ( ${CYAN}build${NC}, ${CYAN}php7${NC} & ${CYAN}php8${NC} )" $NC " " " " " " "7+152"

         CUSTOM_CENTER $LIGHT_CYAN "deldomain <site>" $NC "Delete the Domain extist. ( ${GREEN}<site>.local${NC} )" $NC "➤" " " " " "7+152"
         CUSTOM_CENTER $LIGHT_CYAN "deldomain <site> yes" $NC "Delete the Domain extist and directory ( ${GREEN}<site>.local${NC} )" $NC "➤" " " " " "7+152"

         CUSTOM_CENTER $LIGHT_CYAN "delsubdomain <site>" $NC "Delete the SubDomain extist. ( ${GREEN}<site>.${COMPOSE_PROJECT_NAME,,}.local${NC} )" $NC "➤" " " " " "7+152"
         CUSTOM_CENTER $LIGHT_CYAN "delsubdomain <site> yes" $NC "Delete the SubDomain extist and directory ( ${GREEN}<site>.${COMPOSE_PROJECT_NAME,,}.local${NC} )" $NC "➤" " " " " "7+152"
      else
         echo -e ""
         CUSTOM_LEFT $NC "Docker :" $LIGHT_GRAY " " $LIGHT_CYAN "☑" " " " " 4
         CUSTOM_CENTER $LIGHT_CYAN "up" $NC "Start all containers." $NC "➤" " " " " "7+152"
      fi
   fi
}