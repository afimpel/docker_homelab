#!/bin/bash

############################################################
# generate-override                                        #
############################################################

generate-override()
{
    openCD $0
    more /etc/hosts | grep "${COMPOSE_PROJECT_NAME,,}"  | sort | uniq > hostsfile.conf
    NGINX_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' homelab-webserver)
    # Crear el archivo override
    more hostsfile.conf | while read -r ip hostname extras; do
        if [ "$ip" == "#" ]; then
            echo;
        elif [ ! -z "$hostname" ]; then
            echo "      - \"$hostname:$NGINX_IP\"" >> DOCKER/dockerDATA.yml
            # Si hay hostnames adicionales en la misma línea
            for extra in $extras; do
                URLSnginx=$(echo "$extra" | cut -d "-" -f 1)
                if [ "$URLSnginx" != "nginx" ]; then
                    echo "      - \"$extra:$NGINX_IP\"" >> DOCKER/dockerDATA.yml
                fi
            done
        fi
    done

cat << EOF > DOCKER/docker-compose.override.yml
services:
  homelab-php7:
    extra_hosts:
      - "host.docker.internal:host-gateway"
EOF
sort DOCKER/dockerDATA.yml | uniq >> DOCKER/docker-compose.override.yml

cat << EOF >> DOCKER/docker-compose.override.yml

  homelab-php8:
    extra_hosts:
      - "host.docker.internal:host-gateway"
EOF
sort DOCKER/dockerDATA.yml | uniq >> DOCKER/docker-compose.override.yml

cat << EOF >> DOCKER/docker-compose.override.yml

  homelab-webserver:
    extra_hosts:
      - "host.docker.internal:host-gateway"
EOF
sort DOCKER/dockerDATA.yml | uniq >> DOCKER/docker-compose.override.yml
rm DOCKER/dockerDATA.yml
}