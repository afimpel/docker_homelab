#!/bin/bash

############################################################
# open                                                     #
############################################################

open()
{
   openCD $0
   rightH1 $YELLOW "OPEN ( ${COMPOSE_PROJECT_NAME} )" $WHITE '✔' "." 
   ln
   if [ "$1" == "browser" ] && [ $OPEN_BROWSER == true ]; then
        rightH1 $LIGHT_CYAN "Opening Browser" $WHITE '✔' "."
        rightH1 $LIGHT_CYAN "List all websites" $WHITE '✔' "."
        www
        ln
        rightH1 $LIGHT_CYAN "Preparing to open websites" $WHITE '✔' "."
        domainsOpens="https://www.${COMPOSE_PROJECT_NAME,,}.local $(jq -r '[.items[] | select(.urlType == "www") | .url] | join(" ")' www/dash/domains.json)"
        local domainsOpens_count=${#domainsOpens}
        domainsOpens_count=$(( domainsOpens_count - 1 ))
        leftH1 $WHITE "$OPEN_BROWSER_COMMAND $domainsOpens" $LIGHT_CYAN "☑" " " "☑" "4+${domainsOpens_count}"
        nohup $OPEN_BROWSER_COMMAND $domainsOpens > /dev/null 2>&1 &
   elif [ "$1" == "code" ] && [ $OPEN_CODE == true ]; then
        rightH1 $LIGHT_CYAN "Opening editor" $WHITE '✔' "."
        leftH1 $WHITE "$OPEN_CODE_COMMAND $(pwd)/" $LIGHT_CYAN "☑" " " "☑" "4+1"
        nohup $OPEN_CODE_COMMAND $(pwd)/ > /dev/null 2>&1 &
   elif [ "$1" == "terminal" ] && [ $OPEN_TERMINAL == true ]; then
        rightH1 $LIGHT_CYAN "Opening Terminal" $WHITE '✔' "."
        if [ $OPEN_TERMINAL_COMMAND == "tilix" ]; then
            OPEN_TERMINAL_COMMAND="tilix --working-directory=$(pwd)"
        elif [ $OPEN_TERMINAL_COMMAND == "uxterm" ]; then
            OPEN_TERMINAL_COMMAND="uxterm -e 'cd $(pwd); $SHELL'"
        else
            OPEN_TERMINAL_COMMAND="$OPEN_TERMINAL_COMMAND $(pwd)"
        fi
        leftH1 $WHITE "$OPEN_TERMINAL_COMMAND" $LIGHT_CYAN "☑" " " "☑" "4+1"
        nohup $OPEN_TERMINAL_COMMAND > /dev/null 2>&1 &
   else
        rightH1 $LIGHT_CYAN "No open options selected or invalid option!" $WHITE '✔' "." 
   fi
}