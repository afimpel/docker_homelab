<?php
$datebase_server = "homelab-mariadb";
$datebase_user = getenv('DB_USER');
$datebase_pass = getenv('DB_PASSWORD');
$datebase_datebase = getenv('DB_DATABASE');
$datebase_port = getenv('DB_PORT');

$adminer_server = "server=$datebase_server&username=$datebase_user";
