#!/bin/bash

############################################################
# Utils                                                    #
############################################################

LIGTH_GREEN='\033[1;32m'
LIGTH_CYAN='\033[1;36m'
CYAN='\033[0;36m'
YELLOW='\033[38;5;220m'
GREEN="\033[38;5;48m" 
WHITE="\033[1;97m"
NC='\033[0m' # No Color
RED='\033[0;91m'
LIGTH_RED='\033[1;91m'


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
    R1 $WHITE "Compose use: ${COMPOSE_PROJECT_NAME^^} ✔" $LIGTH_GREEN "☑" "."
}
startup() {
    cd $(dirname $0)
    if [ -f "logs/startup.pid" ]; then
        startup=$(cat logs/startup.pid)
        CUSTOM $LIGTH_CYAN "Startup" $NC "$startup" $LIGTH_GREEN "⏲" ":" "⏲" 0
    fi
}
footer() {
    ln
    startup
    dockerV=$(docker -v)
    dockerCompose=$(docker compose version)
    CUSTOM $LIGTH_CYAN "$dockerCompose" $LIGTH_GREEN "$dockerV" $WHITE "☑" "." "☑" 0
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
    cd $(dirname $0)/logs
    find . -type f -name "*.log"  -delete -exec echo " 🗑 removed '{}'" \; 
}

exist (){ 
    if ! [ -x "$(command -v $1)" ]; then
        R1 $RED "NOT installed" $LIGTH_RED "✘" "."
        colorize $LIGTH_RED " ⮡ Require: \'$1\'   "
        exit
    fi
}