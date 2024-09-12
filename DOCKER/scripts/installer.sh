#!/bin/bash

############################################################
# Installer                                                #
############################################################
installer()
{
   h1 $YELLOW 'Install project ' '✔' "."
   ln
   if [ -f "${COMPOSE_PROJECT_NAME,,}.md" ]; then
      exit
   fi
   cp -v DOCKER/.env.dist DOCKER/.env
   set -a && source DOCKER/.env && set +a
   mkcert -install
   cp $HOME/.local/share/mkcert/rootCA* DOCKER/certs/mkcert
   cp -v DOCKER/examples/installer-homelab-local.conf DOCKER/images/nginx/sites/main_${COMPOSE_PROJECT_NAME,,}_local.conf
   sed -i "s/COMPOSE_PROJECT_NAME/${COMPOSE_PROJECT_NAME,,}/g" DOCKER/images/nginx/sites/main_${COMPOSE_PROJECT_NAME,,}_local.conf

   cd DOCKER/certs
   mkcert ${COMPOSE_PROJECT_NAME,,}.local www.${COMPOSE_PROJECT_NAME,,}.local adminer.${COMPOSE_PROJECT_NAME,,}.local mailhog.${COMPOSE_PROJECT_NAME,,}.local redis.${COMPOSE_PROJECT_NAME,,}.local php8.${COMPOSE_PROJECT_NAME,,}.local php7.${COMPOSE_PROJECT_NAME,,}.local localhost 127.0.0.1 ::1
   mv ${COMPOSE_PROJECT_NAME,,}.local*-key.pem certs_default-key.pem
   mv ${COMPOSE_PROJECT_NAME,,}.local*.pem certs_default.pem
   echo -e "127.0.0.1\t\t${COMPOSE_PROJECT_NAME,,}.local www.${COMPOSE_PROJECT_NAME,,}.local adminer.${COMPOSE_PROJECT_NAME,,}.local mailhog.${COMPOSE_PROJECT_NAME,,}.local redis.${COMPOSE_PROJECT_NAME,,}.local php8.${COMPOSE_PROJECT_NAME,,}.local php7.${COMPOSE_PROJECT_NAME,,}.local" | sudo tee -a /etc/hosts
   cd ../..
   echo -e "# HomeLAB: " > ${COMPOSE_PROJECT_NAME,,}.md
   echo -e " *  [WWW](https://www.${COMPOSE_PROJECT_NAME,,}.local) :: WELCOME" >> ${COMPOSE_PROJECT_NAME,,}.md
   echo -e " *  [Adminer](https://adminer.${COMPOSE_PROJECT_NAME,,}.local) :: Adminer" >> ${COMPOSE_PROJECT_NAME,,}.md
   echo -e " *  [Redis Commander](https://redis.${COMPOSE_PROJECT_NAME,,}.local) :: Redis Commander" >> ${COMPOSE_PROJECT_NAME,,}.md
   echo -e " *  [MailHOG](https://mailhog.${COMPOSE_PROJECT_NAME,,}.local) :: MailHOG" >> ${COMPOSE_PROJECT_NAME,,}.md
   echo -e " *  [PHP7](https://php7.${COMPOSE_PROJECT_NAME,,}.local) :: PHP7 info" >> ${COMPOSE_PROJECT_NAME,,}.md
   echo -e " *  [PHP8](https://php8.${COMPOSE_PROJECT_NAME,,}.local) :: PHP8 info" >> ${COMPOSE_PROJECT_NAME,,}.md
   echo -e "\n\n# SITIOS " >> ${COMPOSE_PROJECT_NAME,,}.md
   h1 $YELLOW 'DONE ' '✔' "."
   ln
   help
}
