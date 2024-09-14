<?php
// Ruta del directorio a listar
$directory = '../sites/';
$files = scandir($directory);
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>LEMP STACK -- <?php echo strtoupper(getenv('COMPOSE_PROJECT_NAME')); ?> </title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootswatch@4.5.2/dist/spacelab/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-mfizz/2.4.1/font-mfizz.min.css" integrity="sha512-Cdvnk1SFWqcb3An6gMyqDRH40Js8qmsWcSK10I2gSifCe2LilaPMsHd6DldEvQ3uIlCb1qdRUrNeAFFleOu4xQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>

<body style="padding-top: 96px;">
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">

        <div class="container">
            <a href="./" class="navbar-brand"><i class="icon-docker"></i> LEMP</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarResponsive">
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" target="_blank" href="//php7.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/"><i class="icon-php"></i> PHP7</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" target="_blank" href="//php8.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/"><i class="icon-php"></i> PHP8</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" target="_blank" href="//adminer.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/"><i class="icon-database"></i> Adminer</a>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" data-bs-toggle="dropdown" href="#" id="sites">Sites</a>
                        <div class="dropdown-menu" aria-labelledby="sites">
                            <?php
// Obtener todos los archivos y carpetas del directorio
foreach ($files as $file) {
    if ($file !== '.' && $file !== '..') {
        if (is_dir($directory . $file)) { ?>
                            <a title="<?= $file.".".strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local" target="_blank" class="dropdown-item" href="//<?= $file;?>.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local"><i class="icon-nginx mr-2"></i> <?= $file; ?> </a>
                            <?php }}} ?>
                        </div>
                    </li>
                </ul>
                <ul class="navbar-nav ml-md-auto">
                    <li class="nav-item">
                        <a target="_blank" rel="noopener" class="nav-link" href="https://github.com/afimpel/docker_homelab"><i class="bi bi-github"></i> GitHub</a>
                    </li>
                    <li class="nav-item">
                        <a target="_blank" rel="noopener" class="nav-link" href="https://twitter.com/afimpel"><i class="bi bi-twitter"></i> Twitter</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
    <div class="container">
        <h1 class="title text-success">
            <i class="icon-docker"></i> LEMP STACK (<em> <?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?> </em>)
        </h1>
        <small class="muted">PHP / Composer / Nginx / MariaDB / Adminer / Redis</small>
        <h2 class="subtitle">
            Your local development environment in Docker
        </h2>
    </div>
    <div class="container-fluid py-2">
        <div class="rounded row border border-info m-2 p-2 py-4">
            <div class="col-12 col-md-4">
                <h3 class="title is-3 has-text-centered"><i class="icon-docker"></i> Environment</h3>
                <hr class="my-1">
                <div class="list-group">
                    <span class="list-group-item d-flex justify-content-between align-items-center py-1">
                        <span><i class="icon-nginx mr-2"></i> Server:</span>
                        <small class="badge text-light bg-info rounded-pill px-2">
                            <?= $_SERVER['SERVER_SOFTWARE']; ?>
                        </small>
                    </span>
                    <a href="//php8.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/" target="_blank" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center py-1">
                        <span><i class="icon-php mr-2"></i> PHP8:</span>
                        <small class="badge text-light bg-info rounded-pill px-2">
                            <?= phpversion(); ?>
                        </small>
                    </a>
                    <a href="//adminer.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/?server=homelab-mariadb&username=<?= getenv('MARIADB_USER'); ?>" target="_blank" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center py-1">
                        <span><i class="icon-mariadb mr-2"></i> mariaDB:</span>
                        <small class="badge text-light bg-info rounded-pill px-2">
                            <?php
                            try {
                                $link = mysqli_connect("homelab-mariadb", getenv('MARIADB_USER'), getenv('MARIADB_PASSWORD'), null);
                                if (mysqli_connect_errno()) {
                                    printf("%s", mysqli_connect_error());
                                } else {
                                    echo mysqli_get_server_info($link);
                                }                               
                            } catch (\Throwable $th) {
                                //throw $th;
                            } ?>
                        </small>
                    </a>
                </div>
                <hr class="my-1">
                <a href="//adminer.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/?server=homelab-mariadb&username=<?= getenv('MARIADB_USER'); ?>" target="_blank" class="w-100 btn btn-outline-info p-1">
                    <small class="d-flex justify-content-between align-items-center px-1">
                        <span><i class="icon-mysql-alt mr-2"></i> Server:</span>
                        <b class="px-0">
                        homelab-mariadb
                        </b>
                    </small>
                    <small class="d-flex justify-content-between align-items-center px-1">
                        <span><i class="icon-mysql-alt mr-2"></i> User:</span>
                        <b class="px-0">
                            <?= getenv('MARIADB_USER'); ?>
                        </b>
                    </small>
                    <small class="d-flex justify-content-between align-items-center px-1">
                        <span><i class="icon-mysql-alt mr-2"></i> Password:</span>
                        <b class="px-0">
                        <?= getenv('MARIADB_PASSWORD'); ?>
                        </b>
                    </small>
                </a>
                <h3 class="title my-2 has-text-centered"><i class="icon-google-developers"></i> Quick Links</h3>
                <hr class="my-1">
                <div class="list-group">
                    <a title="php7.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local" target="_blank" class="list-group-item list-group-item-action p-0 px-2" href="//php7.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/" style="font-size: small;"><i class="icon-php mr-2"></i>php7 -> phpinfo()</a>
                    <a title="php8.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local" target="_blank" class="list-group-item list-group-item-action p-0 px-2" href="//php8.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/" style="font-size: small;"><i class="icon-php mr-2"></i>php8 -> phpinfo()</a>
                    <a title="adminer.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local" target="_blank" class="list-group-item list-group-item-action p-0 px-2" href="//adminer.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/" style="font-size: small;"><i class="icon-database mr-2"></i> adminer</a>
                    <a title="redis.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local" target="_blank" class="list-group-item list-group-item-action p-0 px-2" href="//redis.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/" style="font-size: small;"><i class="icon-redis mr-2"></i> redis</a>
                    <a title="mailhog.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local" target="_blank" class="list-group-item list-group-item-action p-0 px-2" href="//mailhog.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/" style="font-size: small;"><i class=" icon-bomb mr-2"></i> mailhog</a>
                </div>
            </div>
            <div class="col-12 col-md-4">
                <h3 class="title is-3 has-text-centered"><i class="icon-mysql"></i> Database List</h3>
                <hr class="my-1">
                <div class="list-group">
                    <?php
                    try {
                        if (!$link) {
                            throw new Exception("Fatal Error");
                        }
                        $set = mysqli_query($link, 'SHOW DATABASES;');
                        if (!$set) {
                            throw new Exception("Error en la consulta: " . mysqli_error($link));
                        }
                        while ($db = mysqli_fetch_row($set)) { ?>
                            <a target="_blank" class="list-group-item list-group-item-action py-1" href="//adminer.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/?server=homelab-mariadb&username=<?= getenv('MARIADB_USER'); ?>&db=<?= $db[0]; ?>"><i class="icon-database mr-2"></i> <?= $db[0]; ?> </a>
                        <?php }
                        mysqli_free_result($set);
                        mysqli_close($link);
                    } catch (\Exception $e) {
                        echo $e->getMessage();
                    } ?>
                </div>          
            </div>
            <div class="col-12 col-md-4">
                <h3 class="title is-2 has-text-centered"><i class="icon-nginx"></i> Sites List</h3>
                <hr class="my-1">
                <div class="list-group">
                <?php
// Obtener todos los archivos y carpetas del directorio
foreach ($files as $file) {
    if ($file !== '.' && $file !== '..') {
        if (is_dir($directory . $file)) { ?>
                        <a title="<?= $file.".".strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local" target="_blank" class="list-group-item list-group-item-action py-1" href="//<?= $file.".".strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local"><i class="icon-nginx-alt mr-2"></i> <?= $file; ?> </a>
                    <?php }}}
                ?>
                </div>
            </div>
        </div>
        <hr class="my-3">
        <div class="container border border-success rounded p-2">
            <h3 class="text-center"><i class="icon-shell"></i> access to php composer:</h3>
            <ol>
                <li>Open terminal (ej: xterm, gnome-terminal)</li>
                <li>
                    <ul>
                        <li>for <b>PHP7</b>, type this command: <code>docker exec -it homelab-php7 bash</code></li>
                        <li>for <b>PHP8</b>, type this command: <code>docker exec -it homelab-php8 bash</code></li>
                    </ul>
                </li>
                <li>exit: <code>exit</code> o <code>ctrl+d</code> </li>
            </ol>

        </div>

    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
</body>

</html>