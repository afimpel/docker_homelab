<?php
$database_server = "homelab-database";
$cache_server = "homelab-cache";
$mailer_server = "homelab-mailer";
$cache_port = getenv('REDIS_PORT');
$mailer_smtp_port = getenv('SMTP_PORT');
$database_user = getenv('DATABASE_USER');
$database_pass = getenv('DATABASE_PASSWORD');
$database_database = getenv('DATABASE_DATABASE');
$database_port = getenv('DATABASE_PORT');

$adminer_server = "server=$database_server&username=$database_user";

$mailer = [
    'server' => [
        'host' => $mailer_server,
        'port' => $mailer_smtp_port,
        'name' => 'Mailpit',
        'icon' => 'bi bi-envelope-paper-fill',
    ]
];