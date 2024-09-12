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
- Mailhog (gui para Mails)

## Configuración e instalación

  1. Clon del Repo y `cd docker_homelab`
  2. Hacer una copia del archivo `DOCKER/.env.dist` a `DOCKER/.env`
  3. Modificar el valor de la variable `CUSTOMUSER` con el usuario del host
  4. Modificar los valores de las otras variables del archivo `./DOCKER/.env`

  5. Descargar e instalar [mkcert](https://github.com/FiloSottile/mkcert)

```sh
# apt-get
sudo apt install mkcert -y
```
  6. para instalar el Proyecto 

```sh
# HomeLAB
bash homelab install
```

---

# HomeLAB Sitios
*   https://www.homelab.local/
*   https://adminer.homelab.local 
*   https://maildog.homelab.local 
*   https://redis.homelab.local
*   https://php8.homelab.local
*   https://php7.homelab.local

