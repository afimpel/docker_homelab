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
    formatDate=$(date --date="@$1" +'%x | %X')
    echoData="$segundos seg"
    if [ $minutos -gt 0 ]; then
        echoData="$minutos min, $echoData"
    fi
    if [ $horas -gt 0 ]; then
        echoData="$horas hs, $echoData"
    fi
    echo "$echoData | $formatDate"
}

colorize () {
    printf "$1 $2\n${NC}"
}

ln () {
    printf "\n"
}
R1 () {
    data=$(completeLine "$2" "$5" 1);
    printf " ${3}$4${NC}$1 $data ${3}$4${NC}\n${NC}"
}

CUSTOM () {
    data=$(completeLine "$2" "$7" 3 "$4" $9);
    printf " ${5}$6${NC}$1 $2$3 $data ${5}$8${NC}\n${NC}"
}

L1 () {
    data=$(completeLine "$2" "$5" 2);
    printf " ${3}$4${NC}$1 $data ${3}$4${NC}\n${NC}"
}
header() {
    R1 $WHITE "Compose use: ${COMPOSE_PROJECT_NAME^^} ✔" $LIGHT_GREEN "☑" "."
}
startup() {
    cd $(dirname $0)
    if [ -f "logs/startup.pid" ]; then
        startup=$(cat logs/startup.pid)
        startupDate=$(diffTime "$startup")
        CUSTOM $LIGHT_CYAN "Startup" $NC "$startupDate" $LIGHT_GREEN "⏲" ":" "⏲" 0
    fi
}
footer() {
    ln
    startup
    dockerV=$(docker -v)
    dockerCompose=$(docker compose version)
    CUSTOM $LIGHT_CYAN "$dockerCompose" $LIGHT_GREEN "$dockerV" $WHITE "☑" "." "☑" 0
}


completeLine() {
    if [ "$3" == '3' ]; then
        menos=$(( 8 + $5 ))
    else
        menos=7
    fi
    local input_string="$1$4"
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
    else
        echo "$output_string $input_string"
    fi
}

clear () {
    R1 $YELLOW 'Clear Logs' $WHITE '🗑' "."
    cd $(dirname $0)/
    find . -type f -name "*.log" -delete -printf ' 🗑 REMOVED:\t \0%p \n' | sort
}

exist (){ 
    if ! [ -x "$(command -v $1)" ]; then
        R1 $RED "NOT installed" $LIGHT_RED "✘" "."
        colorize $LIGHT_RED " ⮡ Require: \'$1\'   "
        exit
    fi
}