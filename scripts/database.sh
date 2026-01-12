#!/bin/bash

############################################################
# database                                                 #
############################################################

dumpsdb () {
    clear
    startExec=$(date +'%s')

    openCD $0 
    if [ -f "logs/startup.pid" ]; then
      rightH1 $YELLOW "Dump to file from Database" $WHITE '▾' "."
      docker_bash "homelab-database" "mariadb --version:root"
      ln
      CUSTOM_RIGHT $GREEN 'DUMPS in' $LIGHT_CYAN "$OLDPWD/dumpSQL" $WHITE "✔" "." "✔" 0
      docker_bash "homelab-database" "/opt/db/dump_databases.sh $@:root"
    else
      CUSTOM_RIGHT $NC 'Dumps ...' $LIGHT_RED "The project has not started" $RED "✘" " " "✘" 0
    fi
    ln
    timeExec=$(diffTime "$startExec")
    CUSTOM_RIGHT $WHITE "backup Done:" $LIGHT_GRAY "$timeExec" $WHITE "✔" "." "✔" 0
}

dropdb () {
    startExec=$(date +'%s')

    openCD $0 
    db="$1"
    if [ -n "$db" ]; then
      openCD $0 
      if [ -f "logs/startup.pid" ]; then
        rightH1 $YELLOW "Drop from Database" $WHITE '▾' "."
        docker_bash "homelab-database" "mariadb --version:root"
        ln
        CUSTOM_RIGHT $GREEN 'DUMPS before Drop in' $LIGHT_CYAN "$OLDPWD/dumpSQL/backup" $WHITE "✔" "." "✔" 0
        docker_bash "homelab-database" "/opt/db/drop_databases.sh $@:root"
      else
        CUSTOM_RIGHT $NC 'Drop ...' $LIGHT_RED "The project has not started" $RED "✘" " " "✘" 0
      fi
    fi

    ln
    timeExec=$(diffTime "$startExec")
    CUSTOM_RIGHT $WHITE "Drop Done:" $LIGHT_GRAY "$timeExec" $WHITE "✔" "." "✔" 0
}

createdb () {
    startExec=$(date +'%s')

    openCD $0 
    db="$@"
    
    if [ -n "$db" ]; then
      openCD $0 
      if [ -f "logs/startup.pid" ]; then
        rightH1 $YELLOW "Create Database" $WHITE '▾' "."
        docker_bash "homelab-database" "mariadb --version:root"
        ln
        docker_bash "homelab-database" "/opt/db/create_databases.sh $@:root"
      else
        CUSTOM_RIGHT $NC 'Create ...' $LIGHT_RED "The project has not started." $WHITE "☐" " " "☐" 0
      fi
    fi

    ln
    timeExec=$(diffTime "$startExec")
    CUSTOM_RIGHT $WHITE "Create Done:" $LIGHT_GRAY "$timeExec" $WHITE "✔" "." "✔" 0
}

importdb () {
    startExec=$(date +'%s')

    openCD $0 
    if [ -f "logs/startup.pid" ]; then
      rightH1 $YELLOW "Imported from file to database" $WHITE '▾' "."
      docker_bash "homelab-database" "mariadb --version:root"
      ln
      CUSTOM_RIGHT $GREEN 'DUMPS before Import in' $LIGHT_CYAN "$OLDPWD/dumpSQL/backup" $WHITE "✔" "." "✔" 0
      docker_bash "homelab-database" "/opt/db/import_databases.sh $@:root"
    else
      CUSTOM_RIGHT $NC 'Imported ...' $LIGHT_RED "The project has not started" $RED "✘" " " "✘" 0
    fi

    ln
    timeExec=$(diffTime "$startExec")
    CUSTOM_RIGHT $WHITE "Import Done:" $LIGHT_GRAY "$timeExec" $WHITE "✔" "." "✔" 0
}
