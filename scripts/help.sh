#!/bin/bash

RUNNER_NAME="./homelab"
JSON_FILE="www/dash/json-help.json"
JSON_FILE_Version="www/dash/version.json"

############################################################
# Help                                                     #
############################################################

help()
{
   # Display Help
   openCD $0
   rightH1 $YELLOW 'Help' $WHITE '☐' "." 
   local syntax_from_json=$(jq -r '.syntax' "$JSON_FILE")
   local USERNAME=$(whoami)

   local code_mode="off"
   local modeselect="off"
   
   if [ -f "logs/startup.pid" ]; then
      modeselect="on"
      code_mode="on"
   fi
   if [ -f "logs/makealias.pid" ]; then
      RUNNER_NAME="${COMPOSE_PROJECT_NAME,,}"
   fi
   syntax_from_json="${syntax_from_json//COMPOSE_PROJECT_NAME/${RUNNER_NAME}}"
   ln
 
   rightH1 $WHITE 'Syntax : ' $LIGHT_GREEN '✔' " " 
   CUSTOM_LEFT $LIGHT_GREEN "$syntax_from_json" $LIGHT_GRAY " " $NC "✔" " " " " 7
   ln

   rightH1 $WHITE 'Commands :' $LIGHT_GREEN '✔' " "
   if ! [ -f "${COMPOSE_PROJECT_NAME,,}.md" ]; then 
      CUSTOM_CENTER $LIGHT_CYAN "install" $NC "Install this project." $NC "➤" " " " " "7+20"
   else
      OPTION="$1"
      if [ -z "$OPTION" ]; then
         show_general_help 'list' 'list'
      else
         show_general_help 'list' "$OPTION"
         TAG_FILTER="${OPTION#--}"
         show_general_help "$TAG_FILTER" "$OPTION"
      fi
   fi
}

status()
{
   # Display Help
   openCD $0
   rightH1 $YELLOW 'STATUS ' $WHITE '☐' "." 
   ln
   if ! [ -f "${COMPOSE_PROJECT_NAME,,}.md" ]; then
      CUSTOM_CENTER $LIGHT_CYAN "install" $NC "Install this project" $NC "➤" " " " " "7+20"
   else
      if [ -f "logs/startup.pid" ]; then
         CUSTOM_CENTER $NC "STATUS:" $LIGHT_GREEN "ENABLE" $LIGHT_GREEN "✔" " " "✔" "7+5"
      else
         CUSTOM_CENTER $NC "STATUS:" $LIGHT_RED "DISABLE" $LIGHT_RED "✘" " " "✘" "7+6"
      fi
   fi
}


show_general_help() 
{
   if [ ! -f "$JSON_FILE_Version" ]; then
      echo -e "{ \"startup\":\"$(date)\",\"username\":\"$(whoami)\",\"checkfile\":[],\"version\":{\"php8\":\"8.0\", \"composer8\":\"2.0\", \"php7\":\"7.0\", \"composer7\":\"2.0\", \"dockerCompose\":\"$(docker compose version)\", \"docker\":\"$(docker -v)\"} }" | jq . > $JSON_FILE_Version
   fi
   local filter_tag="${1}"
   local tag_data="$2"
   local USERNAME=$(whoami)
   local runner_name_from_json=$(jq -r '.runner' "$JSON_FILE")
   local versionPHP8=$(jq -r '.version.php8' "$JSON_FILE_Version")
   local composerVersion8=$(jq -r '.version.composer8' "$JSON_FILE_Version")
   local versionPHP7=$(jq -r '.version.php7' "$JSON_FILE_Version")
   local composerVersion7=$(jq -r '.version.composer7' "$JSON_FILE_Version")
   local docker_version=$(jq -r '.version.docker' "$JSON_FILE_Version")
   local docker_compose_version=$(jq -r '.version.dockerCompose' "$JSON_FILE_Version")

   jq -c --arg tag "$filter_tag" --arg modes "$modeselect" '
        .commands[] |
        select(
            (.tags | index($tag)) and
            (.mode == $modes or .mode == "both")
        ) |
        {
            title: .title,
            description: .description,
            command_base: .command,
            options: .options,
            checkfile: .checkfile,
            mode: .mode
        }
   ' "$JSON_FILE" | while read -r cmd_block; do

        cmd_block="${cmd_block//docker_version/$docker_version}"
        cmd_block="${cmd_block//docker_compose_version/$docker_compose_version}"
        cmd_block="${cmd_block//USERNAME/$USERNAME}"
        cmd_block="${cmd_block//COMPOSE_PROJECT_NAME/${COMPOSE_PROJECT_NAME}}"
        cmd_block="${cmd_block//composerVersion8/$composerVersion8}"
        cmd_block="${cmd_block//versionPHP8/$versionPHP8}"
        cmd_block="${cmd_block//composerVersion7/$composerVersion7}"
        cmd_block="${cmd_block//versionPHP7/$versionPHP7}"

        local title=$(echo "$cmd_block" | jq -r '.title')
        local description=$(echo "$cmd_block" | jq -r '.description')
        local command_base=$(echo "$cmd_block" | jq -r '.command_base')
        local options=$(echo "$cmd_block" | jq -c '.options')
        local checkfile=$(echo "$cmd_block" | jq -c '.checkfile')
        local mode=$(echo "$cmd_block" | jq -c '.mode')
        checkfile=${checkfile//\"/}
        mode=${mode//\"/}
        description="${description//docker_version/$docker_version}"
        description="${description//docker_compose_version/$docker_compose_version}"


        if [ -f "logs/$checkfile" ]; then
            continue
        fi
        local description_count=${#description}

        description_count=$(( description_count - 1 ))
        CUSTOM_CENTER $WHITE "$title" $LIGHT_GRAY "$description" $LIGHT_CYAN "☑" " " "☑" "4+${description_count}"

        # Iterar sobre las opciones
        echo "$options" | jq -r 'to_entries[] | "\(.key)@\(.value.description)@\(.value.mode)@\(.value.checkfile)"' | while IFS="@" read -r option_key option_desc option_mode option_checkfile; do
            
            if [ ! -z $option_checkfile ]; then
                if [ -f "logs/$option_checkfile" ]; then
                    continue
                fi
            fi

            
            if [ $option_mode == $code_mode ] || [ $option_mode == "both" ]; then
               ICONS_COLOR=$WHITE
               ICONS_OK=" "
               if [ "$option_key" == "$tag_data" ]; then
                  ICONS_COLOR=$ORANGE
                  ICONS_OK="✔"
               fi
               option_desc_count=${#option_desc}
               option_desc_count=$(( option_desc_count - 1 ))

               if [ -z "$command_base" ]; then
                  CUSTOM_CENTER $LIGHT_CYAN "$RUNNER_NAME $option_key" $LIGHT_GRAY "$option_desc" $ICONS_COLOR "➤" " " "$ICONS_OK" "7+${option_desc_count}"
               else
                  CUSTOM_CENTER $LIGHT_CYAN "$RUNNER_NAME $command_base $option_key" $LIGHT_GRAY "$option_desc" $ICONS_COLOR "➤" " " "$ICONS_OK" "7+${option_desc_count}"
               fi

            fi
        done
        ln
   done
}
