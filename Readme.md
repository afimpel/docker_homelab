# Docker HOMELAB

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

1 - Hacer una copia del archivo `.env.dist` a `.env`

3 - Modificar el valor de la variable `CUSTOMUSER` con el usuario del host

4 - Opcional: Modificar los valores de las otras variables del archivo `.env`

5 - Agregar las siguientes lineas en el arhivo `/etc/hosts`

```
# homelab
127.0.0.1 homelab.local www.homelab.local adminer.homelab.local redis.homelab.local php8.homelab.local php7.homelab.local
```

6 - Descargar e instalar [mkcert](https://github.com/FiloSottile/mkcert)

7 - Ejecutar

```sh
mkcert -install
```

7 - Generar certificados

```sh
cd ./DOCKER/certs
mkcert homelab.local www.homelab.local adminer.homelab.local redis.homelab.local php8.homelab.local php7.homelab.local localhost 127.0.0.1 ::1
```



8 - Renombrar certificados

```sh
mv homelab.local+9-key.pem certs_default-key.pem
mv homelab.local+9.pem certs_default.pem
```

9 - Copiar CA de certificados

```sh
# Obtener path de CA
$ mkcert -CAROOT
/home/<my_user>/.local/share/mkcert # ejemplo

# copiar CA
cd ./DOCKER/certs/mkcert
cp $HOME/.local/share/mkcert/rootCA* ./
```