# Docker HomeLAB

## Instroducción

Los servicios que levanta son los siguientes:
- MariaBD
- Redis
- Adminer (gui para MariaDB)
- Redis Commander (gui para redis)
- Nginx
- PHP8 (con composer)
- PHP7 (con composer)
- Mailtramp

## Configuración e instalación

  1. Hacer una copia del archivo `.env.dist` a `.env`
  2. Modificar el valor de la variable `CUSTOMUSER` con el usuario del host
  3. Modificar los valores de las otras variables del archivo `./DOCKER/.env`
  4. Agregar las siguientes lineas en el arhivo `/etc/hosts`

```sh
# HomeLAB
127.0.0.1 homelab.local www.homelab.local adminer.homelab.local redis.homelab.local php8.homelab.local php7.homelab.local
```

  5. Descargar e instalar [mkcert](https://github.com/FiloSottile/mkcert)
```sh
# apt-get
sudo apt install mkcert -y
```

  6. Ejecutar

```sh
mkcert -install
```

  7. Generar certificados

```sh
cd ./DOCKER/certs
mkcert homelab.local www.homelab.local maildog.homelab.local adminer.homelab.local redis.homelab.local php8.homelab.local php7.homelab.local localhost 127.0.0.1 ::1
```

  8. Renombrar certificados

```sh
mv homelab.local*-key.pem certs_default-key.pem
mv homelab.local*.pem certs_default.pem
```

  9. Copiar CA de certificados

```sh
# Obtener path de CA
$ mkcert -CAROOT
/home/<my_user>/.local/share/mkcert

# copiar CA
cd ./DOCKER/certs/mkcert
cp $HOME/.local/share/mkcert/rootCA* ./
```
## Para usarlo:
```sh
# HomeLAB
bash homelab -h # el help
```

# HomeLAB Sitios
*   https://www.homelab.local/
*   https://adminer.homelab.local 
*   https://maildog.homelab.local 
*   https://redis.homelab.local
*   https://php8.homelab.local
*   https://php7.homelab.local

