#!/bin/bash

############################################################
# Help                                                     #
############################################################

help()
{
   # Display Help
   echo "Syntax: homelab <cmd> <options>"
   echo ""
   echo "options:"
   echo "  -h                          Print this help"
   echo ""
   echo "commands (cmd):"
   echo "  up                          Start containers."
   echo "  ps                          Print started containers"
   echo "  logs                        Docker logs."
   echo "  bash (container-name)       Docker bash in container."
   echo "  php7                        Docker bash in PHP7."
   echo "  php8                        Docker bash in PHP8."
   echo "  newsite (site) (type)       Docker bash in PHP8."
   echo "                              type ( php7, php8 y build )"
   echo "  down                        Stop & down containers."
   echo
}
