#!/bin/bash

############################################################
# preUP                                                    #
############################################################

preUP_fn () {
  directory_cli=$PWD
  startExec0000=$(date +'%s')
  openCD $0
  rightH1 $YELLOW 'preUP' $WHITE '☐' "."
  DATETIME="$(date +%Y%m%d)"
  echo -e "---\t\t ✔ \t${COMPOSE_PROJECT_NAME^^}\t | \t $(date) \t ✔ \t\t---" > logs/preUP/${DATETIME}-00_ALL.log
  find logs/preUP \( -type f -name "*-50*.log" \) -delete -printf "[ 🗑  ]\tREMOVED:\t\t  %p\n" | sort >> logs/preUP/${DATETIME}-00_ALL.log 2>&1
  echo -e " " >> logs/preUP/${DATETIME}-00_ALL.log 2>&1
  for script in config/preUP/*.sh ; do
      if [ -r "$script" ] ; then
              CUSTOM_LEFT $NC "bash $script" $BLUE "" $LIGHT_GREEN "➤" " " "⏲" 7
              startExec0001=$(date +'%s')
              nombre_archivo=$(basename "${script}")
              nombre_base="${nombre_archivo%.*}"
              nuevo_nombre="${DATETIME}-50${nombre_base}.log"
              echo -e "\n---\t\t ✔\t RUN: \tbash $script\t | \t $(date) \t ✔ \t\t---\n" > logs/preUP/$nuevo_nombre
              bash -c "bash $script > logs/preUP/int_$nuevo_nombre 2>&1"
              echo -e "----------- $(date '+%Y-%m-%d %H:%M:%S') -----------\n✔\t RUN: \tbash $script ➤" >> logs/preUP/${DATETIME}-00_ALL.log
              ## cat logs/preUP/int_$nuevo_nombre >> logs/preUP/${DATETIME}-00_ALL.log
              cat logs/preUP/int_$nuevo_nombre >> logs/preUP/$nuevo_nombre
              timeExec0=$(diffTime "$startExec0001")
              echo -e "➤\t Time:\t\t$timeExec0\n---\t\t ✔\t DONE: \t$script\t | \t $(date) \t ✔ \t\t---" >> logs/preUP/$nuevo_nombre
              echo -e "➤\t Time: \t$timeExec0\n➤\t Size: \t$(du -h logs/preUP/$nuevo_nombre)\n----------- $(date '+%Y-%m-%d %H:%M:%S') -----------\n" >> logs/preUP/${DATETIME}-00_ALL.log
              CUSTOM_LEFT $NC "LOG: $nuevo_nombre" $BLUE "Time: $timeExec0 / Size: $(du -sh logs/preUP/$nuevo_nombre | awk '{print $1}')" $LIGHT_GREEN "➤" " " "✔" 12
              echo " "
      fi
  done 
  echo -e "---\t\t ✔ \t${COMPOSE_PROJECT_NAME^^}\t | \t $(date) \t ✔ \t\t---" >> logs/preUP/${DATETIME}-00_ALL.log
  find logs/preUP \( -type f -name "int_*.log" \) -delete -printf "[ 🗑  ]\tREMOVED:\t\t  %p\n" | sort >> logs/preUP/${DATETIME}-00_ALL.log 2>&1
  timeExec=$(diffTime "$startExec0000")
  CUSTOM_LEFT $NC "LOG: ${DATETIME}-00_ALL.log" $BLUE "Size: $(du -sh logs/preUP/${DATETIME}-00_ALL.log | awk '{print $1}')" $LIGHT_GREEN "➤" " " "✔" 7
  CUSTOM_RIGHT $WHITE "preUP Done:" $LIGHT_GRAY "$timeExec" $WHITE "✔" "." "✔" 0
  echo " " >> logs/preUP/${DATETIME}-00_ALL.log
  echo -e "\nTime excution: $timeExec." >> logs/preUP/${DATETIME}-00_ALL.log
  echo -e "➤\t Size: \t$(du -h logs/preUP/${DATETIME}-00_ALL.log)\n----------- $(date '+%Y-%m-%d %H:%M:%S') -----------" >> logs/preUP/${DATETIME}-00_ALL.log
}
