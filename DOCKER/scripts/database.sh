#!/bin/bash

############################################################
# database                                                 #
############################################################

dumpsdb () {
    startExec=$(date +'%s')

    openCD $0 
    if [ -f "logs/startup.pid" ]; then
      rightH1 $YELLOW "Dump to file from Database" $WHITE '▾' "."
      docker_bash "homelab-mariadb" "mariadb --version"
      ln
      CUSTOM_RIGHT $GREEN 'DUMPS in' $LIGHT_CYAN "$OLDPWD/dumpSQL" $WHITE "✔" "." "✔" 0
      docker_bash "homelab-mariadb" "/opt/db/dump_databases.sh $@"
    else
      CUSTOM_RIGHT $GREEN 'Dumps ...' $LIGHT_CYAN "There is nothing to do" $WHITE "☐" " " "☐" 0
      ln
      help
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
        docker_bash "homelab-mariadb" "mariadb --version"
        ln
        CUSTOM_RIGHT $GREEN 'DUMPS before Drop in' $LIGHT_CYAN "$OLDPWD/dumpSQL/backup" $WHITE "✔" "." "✔" 0
        docker_bash "homelab-mariadb" "/opt/db/drop_databases.sh $@"
      else
        CUSTOM_RIGHT $GREEN 'Drop ...' $LIGHT_CYAN "There is nothing to do" $WHITE "☐" " " "☐" 0
      fi
    else
      CUSTOM_RIGHT $GREEN 'Drop ...' $LIGHT_CYAN "There is nothing to do" $WHITE "☐" " " "☐" 0
    fi

    ln
    timeExec=$(diffTime "$startExec")
    CUSTOM_RIGHT $WHITE "Drop Done:" $LIGHT_GRAY "$timeExec" $WHITE "✔" "." "✔" 0
}

createdb () {
    startExec=$(date +'%s')

    openCD $0 
    db="$@"
    echo $db
    if [ -n "$db" ]; then
      openCD $0 
      if [ -f "logs/startup.pid" ]; then
        rightH1 $YELLOW "Create Database" $WHITE '▾' "."
        docker_bash "homelab-mariadb" "mariadb --version"
        ln
        docker_bash "homelab-mariadb" "/opt/db/create_databases.sh $@"
      else
        CUSTOM_RIGHT $GREEN 'Create ...' $LIGHT_CYAN "There is nothing to do." $WHITE "☐" " " "☐" 0
      fi
    else
      CUSTOM_RIGHT $GREEN 'Create ...' $LIGHT_CYAN "There is nothing to do" $WHITE "☐" " " "☐" 0
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
      docker_bash "homelab-mariadb" "mariadb --version"
      ln
      CUSTOM_RIGHT $GREEN 'DUMPS before Import in' $LIGHT_CYAN "$OLDPWD/dumpSQL/backup" $WHITE "✔" "." "✔" 0
      docker_bash "homelab-mariadb" "/opt/db/import_databases.sh $@"
    else
      CUSTOM_RIGHT $NC 'Imported ...' $LIGHT_CYAN "There is nothing to do" $WHITE "☐" " " "☐" 0
      ln
      help
    fi

    ln
    timeExec=$(diffTime "$startExec")
    CUSTOM_RIGHT $WHITE "Import Done:" $LIGHT_GRAY "$timeExec" $WHITE "✔" "." "✔" 0
}
