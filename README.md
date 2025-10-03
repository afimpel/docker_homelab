# Docker HomeLAB ( Linux Version )

## Instroducción

Los servicios que levanta son los siguientes:

- MariaBD
- Valkey (fork de Redis)
- Adminer (gui para MariaDB)
- Redis Commander (gui para redis)
- Nginx
- PHP8 (con composer)
- PHP7 (con composer)
- Mailhog (gui para Mails)
- GoAccess (web log analyzer)

## Configuración e instalación

1. Clon del Repo y `cd docker_homelab`
2. *Configuraciones Opcionales*

    1. Hacer una copia del archivo `DOCKER/.env.dist` a `DOCKER/.env`
    2. Modificar el valor de la variable `USERNAME` con el usuario del host
    3. Modificar los valores de las otras variables del archivo `./DOCKER/.env`

3. Descargar e instalar [mkcert](https://github.com/FiloSottile/mkcert)

```sh
# apt-get (Debian / Ubuntu y derivadas)
sudo apt install mkcert libnss3-tools libnotify-bin -y
```

4. para instalar el Proyecto

```sh
# HomeLAB
bash homelab install
```
