#!/bin/bash

############################################################
# Installer                                                #
############################################################
installer()
{
   USERNAME=$(whoami)
   openCD $0
   CUSTOM_RIGHT $YELLOW "Install project" $LIGHT_GREEN "$USERNAME" $WHITE "▶" "." "▶" 0
   exist 'mkcert'
   ln
   if [ -f "${COMPOSE_PROJECT_NAME,,}.md" ]; then
      leftH1 $LIGHT_CYAN 'The project is already installed.' $WHITE '🖥' "."
      exit
   fi

   if [ ! -f "DOCKER/.env" ]; then
      cp -v DOCKER/.env.dist DOCKER/.env
      sed -i "s/CUSTOMUSER/${USERNAME,,}/g" DOCKER/.env
   fi

   set -a && source DOCKER/.env && set +a
   mkdir DOCKER/certs/mkcert
   mkcert -install
   cp $HOME/.local/share/mkcert/rootCA* DOCKER/certs/mkcert
   cp -v DOCKER/examples/installer-homelab-local.conf config/nginx-sites/main_${COMPOSE_PROJECT_NAME,,}_local.conf
   sed -i "s/COMPOSE_PROJECT_NAME/${COMPOSE_PROJECT_NAME,,}/g" config/nginx-sites/main_${COMPOSE_PROJECT_NAME,,}_local.conf

   dateTime=$(date '+%Y_%m_%d-%s')
   echo -e "${COMPOSE_PROJECT_NAME,,}.local www.${COMPOSE_PROJECT_NAME,,}.local adminer.${COMPOSE_PROJECT_NAME,,}.local goaccess.${COMPOSE_PROJECT_NAME,,}.local mailhog.${COMPOSE_PROJECT_NAME,,}.local redis.${COMPOSE_PROJECT_NAME,,}.local php8.${COMPOSE_PROJECT_NAME,,}.local php7.${COMPOSE_PROJECT_NAME,,}.local localhost 127.0.0.1 ::1;default;${COMPOSE_PROJECT_NAME,,};main_${COMPOSE_PROJECT_NAME,,}_local;certs_default;${dateTime};new" >> mkcert.csv

   cd DOCKER/certs
   mkcert ${COMPOSE_PROJECT_NAME,,}.local www.${COMPOSE_PROJECT_NAME,,}.local adminer.${COMPOSE_PROJECT_NAME,,}.local goaccess.${COMPOSE_PROJECT_NAME,,}.local mailhog.${COMPOSE_PROJECT_NAME,,}.local redis.${COMPOSE_PROJECT_NAME,,}.local php8.${COMPOSE_PROJECT_NAME,,}.local php7.${COMPOSE_PROJECT_NAME,,}.local localhost 127.0.0.1 ::1
   mv ${COMPOSE_PROJECT_NAME,,}.local*-key.pem certs_default-key.pem
   mv ${COMPOSE_PROJECT_NAME,,}.local*.pem certs_default.pem
   
   sudo bash -c "echo -e \"127.0.0.1\t\t${COMPOSE_PROJECT_NAME,,}.local www.${COMPOSE_PROJECT_NAME,,}.local adminer.${COMPOSE_PROJECT_NAME,,}.local goaccess.${COMPOSE_PROJECT_NAME,,}.local mailhog.${COMPOSE_PROJECT_NAME,,}.local redis.${COMPOSE_PROJECT_NAME,,}.local php8.${COMPOSE_PROJECT_NAME,,}.local php7.${COMPOSE_PROJECT_NAME,,}.local\" >> /etc/hosts"

   openCD $0
   echo -e "# HomeLAB: ${COMPOSE_PROJECT_NAME^^}\n" > ${COMPOSE_PROJECT_NAME,,}.md
   echo -e "* [WWW](https://www.${COMPOSE_PROJECT_NAME,,}.local) :: WELCOME" >> ${COMPOSE_PROJECT_NAME,,}.md
   echo -e "* [Adminer](https://adminer.${COMPOSE_PROJECT_NAME,,}.local) :: Adminer" >> ${COMPOSE_PROJECT_NAME,,}.md
   echo -e "* [GoAccess LOG](https://goaccess.${COMPOSE_PROJECT_NAME,,}.local) :: GoAccess LOG" >> ${COMPOSE_PROJECT_NAME,,}.md
   echo -e "* [Redis Insight](https://redis.${COMPOSE_PROJECT_NAME,,}.local) :: Redis Insight" >> ${COMPOSE_PROJECT_NAME,,}.md
   echo -e "* [MailHog](https://mailhog.${COMPOSE_PROJECT_NAME,,}.local) :: MailHog" >> ${COMPOSE_PROJECT_NAME,,}.md
   echo -e "* [PHP7](https://php7.${COMPOSE_PROJECT_NAME,,}.local) :: PHP7 info" >> ${COMPOSE_PROJECT_NAME,,}.md
   echo -e "* [PHP8](https://php8.${COMPOSE_PROJECT_NAME,,}.local) :: PHP8 info" >> ${COMPOSE_PROJECT_NAME,,}.md
   leftH1 $LIGHT_GREEN 'DONE' $WHITE '✔' "."
   ln
   makealias
   ln
   docker_up_master
   ln
   help
   www
}

############################################################
# makealias                                                #
############################################################
makealias()
{
   openCD $0
   if ! [ -f "logs/makealias.pid" ]; then
      date > logs/makealias.pid
      CUSTOM_RIGHT $YELLOW "Make alias" $LIGHT_GREEN "${COMPOSE_PROJECT_NAME,,}" $WHITE "▶" "." "▶" 0
      ln

      rightH1 $LIGHT_GREEN 'ZSH' $WHITE '✔' "."
      echo -e "alias ${COMPOSE_PROJECT_NAME,,}=$PWD/homelab">>~/.aliasrc
      echo -e "alias ${COMPOSE_PROJECT_NAME,,}-php7=$PWD/homelab-php7">>~/.aliasrc
      echo -e "alias ${COMPOSE_PROJECT_NAME,,}-php8=$PWD/homelab-php8">>~/.aliasrc
      ln
      
      rightH1 $LIGHT_GREEN 'BASH' $WHITE '✔' "."
      echo -e "alias ${COMPOSE_PROJECT_NAME,,}=$PWD/homelab">>~/.bash_aliases
      echo -e "alias ${COMPOSE_PROJECT_NAME,,}-php7=$PWD/homelab-php7">>~/.bash_aliases
      echo -e "alias ${COMPOSE_PROJECT_NAME,,}-php8=$PWD/homelab-php8">>~/.bash_aliases
      ln

      leftH1 $LIGHT_GREEN 'DONE' $WHITE '✔' "."
   fi
}
