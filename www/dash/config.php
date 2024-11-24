<?php
$datebase_server = "homelab-mariadb";
$datebase_user = getenv('MARIADB_USER');
$datebase_pass = getenv('MARIADB_PASSWORD');
$datebase_datebase = getenv('MARIADB_DATABASE');
$datebase_port = getenv('MARIADB_PORT');

$adminer_server = "server=$datebase_server&username=$datebase_user";
