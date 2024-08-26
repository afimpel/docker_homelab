#!/bin/bash
typefile=$2
sites=$1
mkdir -p www/sites/${sites}
mkcert -install

cp -v DOCKER/examples/examplesite-${typefile}-local.conf DOCKER/images/nginx/sites/${typefile}-${sites}_homelab_local.conf
sed -i "s/examplesite/${sites}/g" DOCKER/images/nginx/sites/${typefile}-${sites}_homelab_local.conf

echo -e "127.0.0.1\t\t${sites}.homelab.local www.${sites}.homelab.local" | sudo tee -a /etc/hosts

cd DOCKER/certs

mkcert ${sites}.homelab.local www.${sites}.homelab.local
mv -v ${sites}.homelab.local+1.pem certs_${sites}_homelab_local.pem 
mv -v ${sites}.homelab.local+1-key.pem certs_${sites}_homelab_local-key.pem 

cd ../..
echo -e "done ... (${sites}.homelab.local) "
more  DOCKER/images/nginx/sites/${typefile}-${sites}_homelab_local.conf | grep server_name | head -1

echo -e "*  [${sites^^}](https://${sites}.homelab.local) :: ${typefile^^}" >> homelab.md

docker restart homelab-webserver