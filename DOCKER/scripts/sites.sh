#!/bin/bash

############################################################
# newsite                                                  #
############################################################

newsite()
{
   sites=${1,,}

   subcommand=${2,,}

   case "$subcommand" in
      php8)
         typefile="php8";
         subdir="public";
      ;;
      php7)
         typefile="php7";
         subdir="public";
      ;;
      build)
         typefile="build";
         subdir="build";
      ;;
      *)
         typefile="build";
         subdir="build";
      ;;
   esac
   colorize $YELLOW ">> ${typefile^^} :: https://${sites}.homelab.local"
   ln
   mkdir -p www/sites/${sites}/${subdir}
   mkcert -install

   cp -v DOCKER/examples/examplesite-${typefile}-local.conf DOCKER/images/nginx/sites/${typefile}-${sites}_homelab_local.conf
   sed -i "s/examplesite/${sites}/g" DOCKER/images/nginx/sites/${typefile}-${sites}_homelab_local.conf

   echo -e "127.0.0.1\t\t${sites}.homelab.local www.${sites}.homelab.local" | sudo tee -a /etc/hosts

   cd DOCKER/certs

   mkcert ${sites}.homelab.local www.${sites}.homelab.local
   mv -v ${sites}.homelab.local*-key.pem certs_${sites}_homelab_local-key.pem 
   mv -v ${sites}.homelab.local*.pem certs_${sites}_homelab_local.pem 

   cd ../..
   more DOCKER/images/nginx/sites/${typefile}-${sites}_homelab_local.conf | grep server_name | head -1
   if [ ! -f "homelab.md" ]; then
      echo "# SITIOS " > homelab.md
   fi
   echo -e " *  [${sites^^}](https://${sites}.homelab.local) :: ${typefile^^}" >> homelab.md
   docker restart homelab-webserver
   colorize $LIGTH_CYAN "   done ... (${sites}.homelab.local) "
   ln
}
