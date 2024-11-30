<?php
$datebase_server = "homelab-database";
$datebase_user = getenv('DATABASE_USER');
$datebase_pass = getenv('DATABASE_PASSWORD');
$datebase_datebase = getenv('DATABASE_DATABASE');
$datebase_port = getenv('DATABASE_PORT');

$adminer_server = "server=$datebase_server&username=$datebase_user";
