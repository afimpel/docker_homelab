#!/bin/bash

############################################################
# Supervisor                                               #
############################################################

newSupervisor()
{
    typeName=${2,,}
    subcommand=${3}

    case "$typeName" in
        php8)
            subdir="";
        ;;
        php7)
            subdir="";
        ;;
        *)
            typeName="php8";
            subdir="";
        ;;
    esac
    base=$(pwd) 
    sites=$(basename $base)
    sites_name="${sites//./_}";
    programName="${typeName,,}_${1,,}_${sites_name}"


    CUSTOM_RIGHT $GREEN "SUPERVISOR: ${typeName^^}" $YELLOW "program:${programName}" $WHITE "⛁" "." "⛁" 0
    ln
    if [ -f "artisan" ]; then
        leftH1 $LIGHT_CYAN "Not laravel Project ... (artisan)" $WHITE "⛁" "."
    else
        ruta="$OLDPWD"
        cambiar="/var"
        rutaPwd="${ruta/${base}/${cambiar}}"
        openCD $0
        if [ ! -f config/supervisor/${typeName,,}/${programName}.conf ]; then
            cp -v DOCKER/examples/supervisor-artisan.conf config/supervisor/${typeName,,}/${programName}.conf
            sed -i "s|programName|${programName}|g" config/supervisor/${typeName,,}/${programName}.conf
            sed -i "s|USERNAME|${USERNAME,,}|g" config/supervisor/${typeName,,}/${programName}.conf
            sed -i "s|artisanCmd|${subcommand}|g" config/supervisor/${typeName,,}/${programName}.conf
            sed -i "s|rutapwd|${rutaPwd}|g" config/supervisor/${typeName,,}/${programName}.conf
            if [ ! -f "${COMPOSE_PROJECT_NAME,,}_supervisor.md" ]; then
                echo -e "# SUPERVISOR\n" > "${COMPOSE_PROJECT_NAME,,}_supervisor.md"
            fi
            echo -e "* php artisan ${subcommand} :: ${typeName^^} => program:$programName" >> "${COMPOSE_PROJECT_NAME,,}_supervisor.md"
            docker restart homelab-${typeName,,}
            # ln
            # mkcert -install
            leftH1 $LIGHT_CYAN " done ... ( SUPERVISOR: program:${programName} )" $WHITE "⛁" "."
        else
            leftH1 $LIGHT_CYAN " The supervisor exists ... (program:${programName})" $WHITE "⛁" "."
        fi
    fi
}

delSupervisor()
{
   programName=${1,,}
   if [ -f config/supervisor/*/${programName}.conf ]; then
      CUSTOM_RIGHT $LIGHT_RED "DELETE ::SUPERVISOR" $YELLOW "program:${programName}" $WHITE "⛁" "." "⛁" 0
      mv -v ${COMPOSE_PROJECT_NAME,,}_supervisor.md ${COMPOSE_PROJECT_NAME,,}_supervisor_bk.md
      grep -v "program:$programName" ${COMPOSE_PROJECT_NAME,,}_supervisor_bk.md > ${COMPOSE_PROJECT_NAME,,}_supervisor.md
      rm ${COMPOSE_PROJECT_NAME,,}_supervisor_bk.md 
      rm -v config/supervisor/*/${programName}.conf
      typeName=$(echo ${programName} | cut -d '_' -f2);
      docker restart homelab-${typeName,,}
   else
      leftH1 $LIGHT_CYAN " The supervisor not exists ... (program:${programName})" $WHITE "⛁" "."
   fi
}

listSupervisor()
{
   openCD $0
   rightH1 $YELLOW "List :: SUPERVISOR" $LIGHT_GREEN '✔' "." 
   input_file="${COMPOSE_PROJECT_NAME,,}_supervisor.md"
   lnline=0
   if [ -f $input_file ]; then
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
                    base="* "
                    cambiar=" "
                    line22="${line/${base}/${cambiar}}"
                    echo -e "\t➤ ${LIGHT_CYAN}$line22${NC}"
            fi
        done < "$input_file"
   fi
}

startedSupervisor()
{
    rightH1 $YELLOW "Start :: SUPERVISOR" $LIGHT_GREEN '✔' "." 
    docker restart homelab-php7
    docker restart homelab-php8
    ln
}