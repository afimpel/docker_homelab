#!/bin/bash

############################################################
# cache                                                    #
############################################################

cache_cmd () {
    startExec000044444=$(date +'%s')
    openCD $0
    directory_cli=$PWD
    unix=$(date '+%Y_%m_%d-%s')
    rightH1 $YELLOW 'Cache' $WHITE '☐' "."
    case "$1" in
        FLUSHALL)
            leftH1 $WHITE "FLUSHALL" $LIGHT_CYAN '☐' "."
            docker_bash "homelab-cache" "redis-cli FLUSHALL:root" 
            timeExec=$(diffTime "$startExec000044444")
            CUSTOM_RIGHT $WHITE "Done: Clear" $LIGHT_GRAY "$timeExec" $WHITE "✔" "." "✔" 0
        ;;
        *)
            help "--cache"
        ;;
    esac

    timeExec=$(diffTime "$startExec000044444")
    CUSTOM_RIGHT $WHITE "cache Done:" $LIGHT_GRAY "$timeExec" $WHITE "✔" "." "✔" 0
}

