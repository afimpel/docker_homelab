#!/bin/bash

############################################################
# Utils                                                    #
############################################################

NC='\033[0m' # No Color
NOCOLOR='\033[0m'
BLACK='\033[0;30m'
BLUE='\033[0;34m'
ORANGE='\033[0;33m'
CYAN='\033[0;36m'
DARK_GRAY='\033[1;30m'
GREEN='\033[0;32m'
LIGHT_BLUE='\033[1;34m'
LIGHT_CYAN='\033[1;36m'
LIGHT_GRAY='\033[0;37m'
LIGHT_GREEN='\033[1;32m'
LIGHT_PURPLE='\033[1;35m'
LIGHT_ORANGE='\033[3;33m'
LIGHT_RED='\033[1;31m'
PURPLE='\033[0;35m'
RED='\033[0;31m'
WHITE='\033[1;37m'
YELLOW='\033[1;33m'

diffTime () {
    segundos1=$(date --date="@$1" +%s)
    segundos2=$(date +%s)
    diferencia=$((segundos2 - segundos1))
    horas=$((diferencia / 3600))
    minutos=$(( (diferencia % 3600) / 60 ))
    segundos=$((diferencia % 60))
    echoData="${segundos}s"
    if [ $minutos -gt 0 ]; then
        echoData="${minutos}m, $echoData"
    fi
    if [ $horas -gt 0 ]; then
        echoData="${horas}h, $echoData"
    fi
    echo "$echoData"
}

colorize () {
    printf "$1 $2\n${NC}"
}

ln () {
    printf "\n"
}
rightH1 () {
    data=$(completeLine "$2" "$5" 1);
    printf " ${3}$4${NC}$1  $data ${3}$4${NC}\n${NC}"
}

CUSTOM_RIGHT () {
    data=$(completeLine "$2" "$7" 3 "$4" $9);
    printf " ${5}$6${NC}$1  $2$3 $data ${5}$8${NC}\n${NC}"
}

CUSTOM_LEFT () {
    data=$(completeLine "$2" "$7" 3 "$4" $9);
    ant_string=""
    ants=$9
    for ((i=0; i<ants; i++)); do
        ant_string+=" "
    done
    printf "$ant_string ${5}$6${NC}$1  $2$3 $data ${5}$8${NC}\n${NC}"
}

CUSTOM_CENTER () {
    data=$(completeLine "$2" "$7" 4 "$4" $(( $9 )));
    ant_string=""
    ants=7
    for ((i=0; i<ants; i++)); do
        ant_string+=" "
    done
    printf "$ant_string ${5}$6${NC}$1  $2$3 $data$4 ${5}$8${NC}\n${NC}"
}

leftH1 () {
    data=$(completeLine "$2" "$5" 2);
    printf " ${3}$4${NC}$1  $data ${3}$4${NC}\n${NC}"
}
header() {
    CUSTOM_RIGHT $WHITE "Compose use: ${COMPOSE_PROJECT_NAME^^} ✔" $LIGHT_GRAY "${USERNAME^^}" $WHITE "☑" "." "☑" 0
}
startup() {
    openCD $0
    if [ -f "logs/startup.pid" ]; then
        startup=$(cat logs/startup.pid)
        startupDate=$(diffTime "$startup")
        CUSTOM_RIGHT $LIGHT_CYAN "Startup" $NC "$startupDate" $LIGHT_GREEN "⏲" ":" "⏲" 0
    fi
}
footer() {
    ln
    startup
    dockerV=$(docker -v)
    dockerCompose=$(docker compose version)
    CUSTOM_RIGHT $LIGHT_CYAN "$dockerCompose" $LIGHT_GREEN "$dockerV" $WHITE "☑" "." "☑" 0
}


completeLine() {
    local input_string="$1$4"
    if [ "$3" == '3' ]; then
        menos=$(( 9 + $5 ))
    elif [ "$3" == '4' ]; then
        input_string="$1"
        menos=$(( 9 + $5 ))
    else
        menos=8
    fi
    local input_string0="$1"
    local input_string1="$4"
    local total_length=$(tput cols)-$menos
    local input_length=${#input_string}
    local num_dots=$((total_length - input_length))

    if [ $num_dots -lt 0 ]; then
        num_dots=1
    fi

    local output_string=""
    for ((i=0; i<num_dots; i++)); do
        output_string+="$2"
    done
    if [ "$3" == '3' ]; then
        echo "$output_string $input_string1"
    elif [ "$3" == '0' ]; then
        echo "$input_string0 $output_string $input_string1"
    elif [ "$3" == '1' ]; then
        echo "$input_string $output_string"
    elif [ "$3" == '2' ]; then
        echo "$output_string $input_string"
    elif [ "$3" == '4' ]; then
        echo "$output_string"
    fi
}

clearLogs () {
    rightH1 $YELLOW 'Clear Logs' $WHITE '🗑' "."
    openCD $0
    find . -type f -name "*.log" -delete -printf " 🗑  REMOVED:\t $LIGHT_RED \0%p $NC\n" | sort
}

exist (){ 
    if ! [ -x "$(command -v $1)" ]; then
        rightH1 $RED "NOT installed" $LIGHT_RED "✘" "."
        colorize $LIGHT_RED " ⮡ Require: \'$1\'   "
        exit
    fi
}
openCD (){ 
    if [ "$(dirname $1)" == "." ]; then
        if [ -f "$PWD/homelab" ]; then
            cd $PWD
        else
            cd $OLDPWD
        fi
    else
        cd $(dirname $1)
    fi
}