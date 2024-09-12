#!/bin/bash

############################################################
# Utils                                                    #
############################################################

LIGTH_GREEN='\033[1;32m'
LIGTH_CYAN='\033[1;36m'
YELLOW='\033[38;5;220m'
GREEN="\033[38;5;48m" 
WHITE="\033[1;97m"
NC='\033[0m' # No Color
RED='\033[0;91m'


colorize () {
    printf "$1$2\n${NC}"
}

ln () {
    printf "\n"
}
h1 () {
    data=$(completar_con_puntos "$3 $2" "$4");
    printf "$1$data $3\n${NC}"
}


function completar_con_puntos {
    local input_string="$1"
    local total_length=$(tput cols)-3
    local input_length=${#input_string}
    local num_dots=$((total_length - input_length))

    if [ $num_dots -lt 0 ]; then
        num_dots=1
    fi

    local output_string="$input_string"
    for ((i=0; i<num_dots; i++)); do
        output_string+="$2"
    done

    echo "$output_string"
}
