<?php
$datebase_server = "homelab-mariadb";
$datebase_user = getenv('HOMELAB_USER');
$datebase_pass = getenv('HOMELAB_PASSWORD');
$datebase_datebase = getenv('HOMELAB_DATABASE');
$datebase_port = getenv('HOMELAB_PORT');

$adminer_server = "server=$datebase_server&username=$datebase_user";
