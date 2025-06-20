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
   if [ -f "logs/makealias.pid" ]; then
      echo -e "\t➤ ${LIGHT_GREEN}${COMPOSE_PROJECT_NAME,,}${NC} <cmd> <options>"
   else
      echo -e "\t➤ ${LIGHT_GREEN}./homelab${NC} <cmd> <options>"
   fi
   ln
   rightH1 $WHITE 'Commands (cmd) : ' $LIGHT_GREEN '✔' " " 
   if ! [ -f "${COMPOSE_PROJECT_NAME,,}.md" ]; then
      CUSTOM_CENTER $LIGHT_CYAN "install" $NC "Install this project." $NC "➤" " " " " "7+132"
   else
      if [ -f "logs/startup.pid" ]; then
         show_general_help $1
         if [ $# -eq 1 ]; then
            case "$1" in
               --all)
                     ln
                     show_alias_help
                     ln
                     show_backup_help
                     ln
                     show_docker_help
                     ln
                     show_db_help
                     ln
                     show_sites_help
                     ln
                     show_supervisor_help
                     ;;
               --docker)
                     ln
                     show_docker_help
                     ;;
               --alias)
                     ln
                     show_alias_help
                     ;;
               --db)
                     ln
                     show_db_help
                     ;;
               --backup)
                     ln
                     show_backup_help
                     ;;
               --sites)
                     ln
                     show_sites_help
                     ;;
               --supervisor)
                     ln
                     show_supervisor_help
                     ;;
            esac
         fi
      else
         CUSTOM_LEFT $NC "Docker :" $LIGHT_GRAY " " $LIGHT_CYAN "☑" " " " " 4
         CUSTOM_CENTER $LIGHT_CYAN "up" $NC "Start all containers." $NC "➤" " " " " "7+132"
         if ! [ -f "logs/makealias.pid" ]; then
            ln
            show_alias_help
         fi
      fi
   fi
}

status()
{
   # Display Help
   openCD $0
   rightH1 $YELLOW 'STATUS ' $WHITE '☐' "." 
   ln
   if ! [ -f "${COMPOSE_PROJECT_NAME,,}.md" ]; then
      CUSTOM_CENTER $LIGHT_CYAN "install" $NC "Install this project." $NC "➤" " " " " "7+132"
   else
      if [ -f "logs/startup.pid" ]; then
         CUSTOM_CENTER $NC "STATUS:" $LIGHT_GREEN "ENABLE" $LIGHT_GREEN "✔" " " " " "7+132"
      else
         CUSTOM_CENTER $NC "STATUS:" $LIGHT_RED "DISABLE" $LIGHT_RED "✘" " " " " "7+132"
      fi
   fi
}


show_general_help() {
         CUSTOM_LEFT $NC "Status :" $LIGHT_GRAY " " $LIGHT_CYAN "☑" " " " " 4
         CUSTOM_CENTER $LIGHT_CYAN "status" $NC "Shows project status whether it is active or not." $NC "➤" " " " " "7+132"
         ln
         CUSTOM_LEFT $NC "Help :" $LIGHT_GRAY " " $LIGHT_CYAN "☑" " " " " 4
         CUSTOM_CENTER $LIGHT_CYAN "help" $NC "Display usage information$(this_msg "" $1 )" $NC "➤" " " " " "7+132"
         CUSTOM_CENTER $LIGHT_GRAY "Opciones disponibles:" $NC "" $NC "☐" " " " " "10+132"
         CUSTOM_CENTER $(this_color "--all" $1 ) "--all" $NC "Show all available help$(this_msg "--all" $1 )" $NC "➤" " " " " "13+132"
         CUSTOM_CENTER $(this_color "--db" $1 ) "--db" $NC "Show help related to the database$(this_msg "--db" $1 )" $NC "➤" " " " " "13+132"
         CUSTOM_CENTER $(this_color "--docker" $1 ) "--docker" $NC "Show help related to Docker$(this_msg "--docker" $1 )" $NC "➤" " " " " "13+132"
         if ! [ -f "logs/makealias.pid" ]; then
            CUSTOM_CENTER $(this_color "--alias" $1 ) "--alias" $NC "Show help related to Alias$(this_msg "--alias" $1 )" $NC "➤" " " " " "13+132"
         fi
         CUSTOM_CENTER $(this_color "--backup" $1 ) "--backup" $NC "Show help related to backup$(this_msg "--backup" $1 )" $NC "➤" " " " " "13+132"
         CUSTOM_CENTER $(this_color "--sites" $1 ) "--sites" $NC "Show help related to sites$(this_msg "--sites" $1 )" $NC "➤" " " " " "13+132"
         CUSTOM_CENTER $(this_color "--supervisor" $1 ) "--supervisor" $NC "Show help related to Supervisor$(this_msg "--supervisor" $1 )" $NC "➤" " " " " "13+132"
}

this_msg() {
   if [ "$1" == "$2" ]; then
      echo ". ( this message )"
   fi
}
this_color() {
   if [ "$1" == "$2" ]; then
      echo -e $LIGHT_CYAN
   else
      echo -e $CYAN
   fi
}

show_docker_help() {
         php7=$(docker_bash "homelab-php7" "php:root" -v | head -1 | cut -d " " -f 2)
         php8=$(docker_bash "homelab-php8" "php:root" -v | head -1 | cut -d " " -f 2)
         composer7=$(docker_bash "homelab-php7" "composer:root" -V | head -1 | cut -d " " -f 3)
         composer8=$(docker_bash "homelab-php8" "composer:root" -V | head -1 | cut -d " " -f 3)

         CUSTOM_LEFT $NC "Docker :" $LIGHT_GRAY " " $LIGHT_CYAN "☑" " " " " 4
         CUSTOM_CENTER $LIGHT_CYAN "ps" $NC "Print started containers." $NC "➤" " " " " "7+132"

         CUSTOM_CENTER $LIGHT_CYAN "restart" $NC "Restart containers." $NC "➤" " " " " "7+132"

         CUSTOM_CENTER $LIGHT_CYAN "clear" $NC "Clear all logs & Restart containers." $NC "➤" " " " " "7+132"

         CUSTOM_CENTER $LIGHT_CYAN "logs" $NC "Docker All logs." $NC "➤" " " " " "7+132"

         CUSTOM_CENTER $LIGHT_CYAN "logs <container_name>" $NC "Docker logs in container." $NC "➤" " " " " "7+132"

         CUSTOM_CENTER $LIGHT_CYAN "down" $NC "Stop & Down containers." $NC "➤" " " " " "7+132"

         CUSTOM_CENTER $LIGHT_CYAN "down clear" $NC "Stop, Down containers & Clear all logs." $NC "➤" " " " " "7+132"

         ln
         CUSTOM_LEFT $NC "Docker Container :" $LIGHT_GRAY " " $LIGHT_CYAN "☑" " " " " 4
         CUSTOM_CENTER $LIGHT_CYAN "bash <container_name>" $NC "Docker bash in container." $NC "➤" " " " " "7+132"

         CUSTOM_CENTER $LIGHT_CYAN "php7-usr" $NC "Docker bash in\t ${YELLOW}PHP $php7${NC}\t\t\t( ${LIGHT_ORANGE}♟ ${USERNAME}${NC} )" $NC "➤" " " " " "7+132"

         CUSTOM_CENTER $LIGHT_CYAN "php7" $NC "Docker bash in\t ${YELLOW}PHP $php7${NC}\t\t\t( ${RED}♚ root${NC} )" $NC "➤" " " " " "7+132"

         CUSTOM_CENTER $LIGHT_CYAN "php7-cli <command>" $NC "Docker CLI in\t ${YELLOW}PHP $php7${NC}\t\t\t( ${RED}♚ root${NC} )" $NC "➤" " " " " "7+132"

         CUSTOM_CENTER $LIGHT_CYAN "php7-composer <command>" $NC "Docker CLI in\t ${YELLOW}PHP $php7${NC} ➤ ${YELLOW}Composer $composer7${NC}\t( ${RED}♚ root${NC} )" $NC "➤" " " " " "7+132"
         
         CUSTOM_CENTER $LIGHT_CYAN "php8-usr" $NC "Docker bash in\t ${YELLOW}PHP $php8${NC}\t\t\t( ${LIGHT_ORANGE}♟ ${USERNAME}${NC} )" $NC "➤" " " " " "7+132"

         CUSTOM_CENTER $LIGHT_CYAN "php8" $NC "Docker bash in\t ${YELLOW}PHP $php8${NC}\t\t\t( ${RED}♚ root${NC} )" $NC "➤" " " " " "7+132"

         CUSTOM_CENTER $LIGHT_CYAN "php8-cli <command>" $NC "Docker CLI in\t ${YELLOW}PHP $php8${NC}\t\t\t( ${RED}♚ root${NC} )" $NC "➤" " " " " "7+132"

         CUSTOM_CENTER $LIGHT_CYAN "php8-composer <command>" $NC "Docker CLI in\t ${YELLOW}PHP $php8${NC} ➤ ${YELLOW}Composer $composer8${NC}\t( ${RED}♚ root${NC} )" $NC "➤" " " " " "7+132"
}

show_db_help() {
         CUSTOM_LEFT $NC "Database :" $LIGHT_GRAY " " $LIGHT_CYAN "☑" " " " " 4
         CUSTOM_CENTER $LIGHT_CYAN "createdb <database_name>" $NC "mariadb database is created specified with its respective user (same name: EX: db pepe_base the user will be: pepe)." $NC "➤" " " " " "7+132"
         CUSTOM_CENTER $LIGHT_CYAN "dumpsdb" $NC "Perform a full backup of all mariadb databases. (excluding system db)" $NC "➤" " " " " "7+132"

         CUSTOM_CENTER $LIGHT_CYAN "dumpsdb <database_name>" $NC "Perform a backup of a specified entire mariadb database." $NC "➤" " " " " "7+132"

         CUSTOM_CENTER $LIGHT_CYAN "importdb <database_name> <file>" $NC "Perform a file import of a specific full mariadb database." $NC "➤" " " " " "7+132"

         CUSTOM_CENTER $LIGHT_CYAN "dropdb <database_name>" $NC "The specified mariadb database is backed up and deleted." $NC "➤" " " " " "7+132"
}

show_backup_help() {
         CUSTOM_LEFT $NC "BackUP :" $LIGHT_GRAY " " $LIGHT_CYAN "☑" " " " " 4
         CUSTOM_CENTER $LIGHT_CYAN "backup" $NC "backup of files (www/DB/Configs)" $NC "➤" " " " " "7+132"
}

show_alias_help() {
   if ! [ -f "logs/makealias.pid" ]; then
         CUSTOM_LEFT $NC "Alias :" $LIGHT_GRAY " " $LIGHT_CYAN "☑" " " " " 4
         CUSTOM_CENTER $LIGHT_CYAN "makealias" $NC "Aliases are created in ZSH and Bash" $NC "➤" " " " " "7+132"
   fi
}

show_sites_help() {
         CUSTOM_LEFT $NC "Sites :" $LIGHT_GRAY " " $LIGHT_CYAN "☑" " " " " 4
         CUSTOM_CENTER $LIGHT_CYAN "listsite" $NC "List all Sites." $NC "➤" " " " " "7+132"

         CUSTOM_CENTER $LIGHT_CYAN "recreate-ssl" $NC "Recreating SSL Certificates." $NC "➤" " " " " "7+132"

         CUSTOM_CENTER $LIGHT_CYAN "legacydomain <site> <type>" $NC "Create the New Domain. (Legacy Code) ( ${GREEN}<site>.local${NC} )" $NC "➤" " " " " "7+132"
         CUSTOM_CENTER $LIGHT_CYAN " " $NC "${GREEN}<type>${NC} ( ${CYAN}build${NC}, ${CYAN}php7${NC} & ${CYAN}php8${NC} )" $NC " " " " " " "7+132"

         CUSTOM_CENTER $LIGHT_CYAN "legacysubdomain <site> <type>" $NC "Create the New SubDomain. (Legacy Code) ( ${GREEN}<site>.${COMPOSE_PROJECT_NAME,,}.local${NC} )" $NC "➤" " " " " "7+132"
         CUSTOM_CENTER $LIGHT_CYAN " " $NC "${GREEN}<type>${NC} ( ${CYAN}build${NC}, ${CYAN}php7${NC} & ${CYAN}php8${NC} )" $NC " " " " " " "7+132"

         CUSTOM_CENTER $LIGHT_CYAN "newdomain <site> <type>" $NC "Create the New Domain. (Framework Code) ( ${GREEN}<site>.local${NC} )" $NC "➤" " " " " "7+132"
         CUSTOM_CENTER $LIGHT_CYAN " " $NC "${GREEN}<type>${NC} ( ${CYAN}build${NC}, ${CYAN}php7${NC} & ${CYAN}php8${NC} )" $NC " " " " " " "7+132"

         CUSTOM_CENTER $LIGHT_CYAN "newsubdomain <site> <type>" $NC "Create the New SubDomain. (Framework Code) ( ${GREEN}<site>.${COMPOSE_PROJECT_NAME,,}.local${NC} )" $NC "➤" " " " " "7+132"
         CUSTOM_CENTER $LIGHT_CYAN " " $NC "${GREEN}<type>${NC} ( ${CYAN}build${NC}, ${CYAN}php7${NC} & ${CYAN}php8${NC} )" $NC " " " " " " "7+132"

         CUSTOM_CENTER $LIGHT_CYAN "deldomain <site>" $NC "Delete the Domain extist. ( ${GREEN}<site>.local${NC} )" $NC "➤" " " " " "7+132"
         CUSTOM_CENTER $LIGHT_CYAN "deldomain <site> yes" $NC "Delete the Domain extist and directory ( ${GREEN}<site>.local${NC} )" $NC "➤" " " " " "7+132"

         CUSTOM_CENTER $LIGHT_CYAN "delsubdomain <site>" $NC "Delete the SubDomain extist. ( ${GREEN}<site>.${COMPOSE_PROJECT_NAME,,}.local${NC} )" $NC "➤" " " " " "7+132"
         CUSTOM_CENTER $LIGHT_CYAN "delsubdomain <site> yes" $NC "Delete the SubDomain extist and directory ( ${GREEN}<site>.${COMPOSE_PROJECT_NAME,,}.local${NC} )" $NC "➤" " " " " "7+132"
}

show_supervisor_help() {
         CUSTOM_LEFT $NC "Supervisor :" $LIGHT_GRAY " " $LIGHT_CYAN "☑" " " " " 4
         CUSTOM_CENTER $LIGHT_CYAN "startsupervisor" $NC "Start all Supervisor." $NC "➤" " " " " "7+132"

         CUSTOM_CENTER $LIGHT_CYAN "listsupervisor" $NC "List all Supervisor. " $NC "➤" " " " " "7+132"

         CUSTOM_CENTER $LIGHT_CYAN "newsupervisor <programName> <type> '<cmd>'" $NC "Create the New Supervisor artisan. (Framework Code) ( ${GREEN}<programName>${NC} )" $NC "➤" " " " " "7+132"
         CUSTOM_CENTER $LIGHT_CYAN " " $NC "${GREEN}<type>${NC} ( ${CYAN}php7${NC} & ${CYAN}php8${NC} )" $NC " " " " " " "7+132"
         CUSTOM_CENTER $LIGHT_CYAN " " $NC "${GREEN}<cmd>${NC} ( Command artisan )" $NC " " " " " " "7+132"

         CUSTOM_CENTER $LIGHT_CYAN "delsupervisor <programName>" $NC "Delete the Supervisor extist. " $NC "➤" " " " " "7+132"
}
