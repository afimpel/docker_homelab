#!/bin/bash

############################################################
# Utils                                                    #
############################################################
directory_cli=$(pwd)

NC='\033[0m' # No Color
NOCOLOR='\033[0m'
BLACK='\033[0;30m'
BLUE='\033[0;34m'
ORANGE='\033[0;33m'
CYAN='\033[0;36m'
DARK_GRAY='\033[1;30m'
GRAY='\033[0;30m'
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
    inputotal="$9";
    ants111=$(echo "$9" | cut -d "+" -f 2)
    ants000=$(echo "$9" | cut -d "+" -f 1);
    if [ "$ants111" -eq "$ants000" ]; then
        ants=0
    else
        ants=$(( $ants000 ))
    fi
    data=$(completeLine "$2" "$7" 4 " " $(( $9 )));
    data2=$(completeLine " " "$7" 4 "$4" $(( $9 )));
    ant_string=""
    for ((i=0; i<ants; i++)); do
        ant_string+=" "
    done
    if [ $ants111 -gt 80 ]; then 
        printf "$ant_string ${5}$6${NC}$1  $2$3 $data  ${5}$8${NC}\n${NC}"
        printf "$ant_string ${5} ${NC}$1   $3 $data2$4 ${5} ${NC}\n${NC}"
    else
        printf "$ant_string ${5}$6${NC}$1  $2$3 $data$4 ${5}$8${NC}\n${NC}"
    fi
}

leftH1 () {
    data=$(completeLine "$2" "$5" 2);
    printf " ${3}$4${NC}$1  $data ${3}$4${NC}\n${NC}"
}
header() {
    CUSTOM_RIGHT $WHITE "Compose use: $LIGHT_CYAN${COMPOSE_PROJECT_NAME^^} ✔" $LIGHT_GRAY "${USERNAME,,}@$(hostname)" $WHITE "☑" "." "☑" "0-10"
}
startup() {
    openCD $0
    if [ -f "logs/startup.pid" ]; then
        startup=$(cat logs/startup.pid)
        startupDate=$(diffTime "$startup")
        CUSTOM_RIGHT $LIGHT_CYAN "Startup" $WHITE "$startupDate" $LIGHT_GREEN "⏲" ":" "⏲" 0
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
write_message () {
    timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    names=${2:-INFO}
    base_name=$(basename $0)
    if [ $DEBUG_MODE == true ]; then
        echo -e "[ $$ | $timestamp ] $1" >> logs/various/${names}-$$-${base_name}.log
    fi
}

clearLogs () {
    startExec0000=$(date +'%s')
    rightH1 $YELLOW 'Clear Logs' $WHITE '🗑' "."
    openCD $0
    find . \( \
        \( -type f -name "*.log" \) -o \
        \( -type f -name "*.out" \) -o \
        \( -type f -name "debug*.xml" \) -o \
        \( -type f -name "debug*.json" \) -o \
        \( -type f -name "ci_sessio*" \) -o \
        \( -path "*/storage/logs/*" -type d \) -o \
        \( -path "./TEMP/*" -type f ! -name ".gitignore" \) \
    \) -delete -printf " 🗑  REMOVED:\t ${LIGHT_RED}%p${NC}\n" | sort
    ln
    timeExec=$(diffTime "$startExec0000")
    send_notify "Clear all logs ..." "trash"
    CUSTOM_RIGHT $WHITE "Done all:" $LIGHT_GRAY "Clear: $timeExec" $WHITE "✔" "." "✔" 0
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

truncar() {
    local texto="$1"
    local limite="$2"
    if [[ ${#texto} -gt $limite ]]; then
        echo "${texto:0:$limite}..."
    else
        echo "$texto"
    fi
}

refactor_fn () {
    directory_cli=$PWD
    startExec0000=$(date +'%s')
    openCD $0
    rightH1 $YELLOW 'Refactor' $WHITE '☐' "."
    DATETIME="$(date +%Y%m%d)"
    echo -e "---\t\t ✔ \t${COMPOSE_PROJECT_NAME^^}\t | \t $(date) \t ✔ \t\t---\n" > logs/refactor/${DATETIME}-00_ALL.log
    rm -v logs/refactor/*-50*.log >> logs/refactor/${DATETIME}-00_ALL.log 2>&1
    for script in scripts/refactor/*.sh ; do
        if [ -r "$script" ] ; then
                CUSTOM_LEFT $NC "bash $script" $BLUE "" $LIGHT_GREEN "➤" " " "⏲" 7
                startExec0001=$(date +'%s')
                nombre_archivo=$(basename "${script}")
                nombre_base="${nombre_archivo%.*}"
                nuevo_nombre="${DATETIME}-50${nombre_base}.log"
                bash -c "bash $script > logs/refactor/int_$nuevo_nombre 2>&1"
                echo -e "----------- $(date '+%Y-%m-%d %H:%M:%S') -----------\n✔\t RUN: \tbash $script ➤\n" >> logs/refactor/${DATETIME}-00_ALL.log
                cat logs/refactor/int_$nuevo_nombre >> logs/refactor/${DATETIME}-00_ALL.log
                timeExec0=$(diffTime "$startExec0001")
                echo " " >> logs/refactor/${DATETIME}-00_ALL.log
                rm -v logs/refactor/int_$nuevo_nombre >> logs/refactor/${DATETIME}-00_ALL.log 2>&1
                echo -e "➤\t Time: \t$timeExec0\n➤\t Size: \t$(du -h logs/refactor/$nuevo_nombre)\n----------- $(date '+%Y-%m-%d %H:%M:%S') -----------\n" >> logs/refactor/${DATETIME}-00_ALL.log
                CUSTOM_LEFT $NC "LOG: $nuevo_nombre" $BLUE "Time: $timeExec0 / Size: $(du -sh logs/refactor/$nuevo_nombre | awk '{print $1}')" $LIGHT_GREEN "➤" " " "✔" 12
                echo " "
        fi
    done 
    timeExec=$(diffTime "$startExec0000")
    CUSTOM_LEFT $NC "LOG: ${DATETIME}-00_ALL.log" $BLUE "Size: $(du -sh logs/refactor/${DATETIME}-00_ALL.log | awk '{print $1}')" $LIGHT_GREEN "➤" " " "✔" 7
    CUSTOM_RIGHT $WHITE "Runonce Done:" $LIGHT_GRAY "$timeExec" $WHITE "✔" "." "✔" 0
    echo -e "\nTime excution: $timeExec." >> logs/refactor/${DATETIME}-00_ALL.log
    echo -e "➤\t Size: \t$(du -h logs/refactor/${DATETIME}-00_ALL.log)\n----------- $(date '+%Y-%m-%d %H:%M:%S') -----------" >> logs/refactor/${DATETIME}-00_ALL.log
}