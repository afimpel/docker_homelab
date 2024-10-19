<?php
// Ruta del directorio a listar
$directorySubdomin = '../subdomains/';
$directoryDomain = '../domains/';
$filesSubdomin = scandir($directorySubdomin);
$filesDomain = scandir($directoryDomain);
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <link rel="icon" href="https://afimpel.github.io/favicon.ico" />
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>LEMP STACK -- <?php echo strtoupper(getenv('COMPOSE_PROJECT_NAME')); ?> </title>
    <link rel="stylesheet" href="https://bootswatch.com/5/spacelab/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-mfizz/2.4.1/font-mfizz.min.css" integrity="sha512-Cdvnk1SFWqcb3An6gMyqDRH40Js8qmsWcSK10I2gSifCe2LilaPMsHd6DldEvQ3uIlCb1qdRUrNeAFFleOu4xQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>

<body style="padding-top: 96px;">
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top" data-bs-theme="dark">

        <div class="container">
            <a href="./" class="navbar-brand"><i class="me-2 icon-docker"></i> LEMP</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarResponsive">
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" target="_blank" href="//php7.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/"><i class="me-2 icon-php"></i> PHP7</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" target="_blank" href="//php8.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/"><i class="me-2 icon-php"></i> PHP8</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" target="_blank" href="//adminer.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/"><i class="me-2 icon-database"></i> Adminer</a>
                    </li>
                    <?php if (count($filesDomain) > 3){?>          
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" data-bs-toggle="dropdown" href="#" id="domains"><i class="me-2 icon-ghost"></i> Domain (<?php echo count($filesDomain)-3;?>)</a>
                        <div class="dropdown-menu" aria-labelledby="domains">
                            <?php echo listSites($filesDomain, $directoryDomain, "dropdown-item");?>
                        </div>
                    </li>
                    <?php }
                    if (count($filesSubdomin) > 3){?>
                     <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" data-bs-toggle="dropdown" href="#" id="sites"><i class="me-2 icon-ghost"></i> SubDomain (<?php echo count($filesSubdomin)-3;?>)</a>
                        <div class="dropdown-menu" aria-labelledby="sites">
                            <?php echo listSites($filesSubdomin, $directorySubdomin, "dropdown-item",".".strtolower(getenv('COMPOSE_PROJECT_NAME')));?>
                        </div>
                    </li>
                <?php } ?>
                </ul>
                <ul class="navbar-nav ms-md-auto">
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
    <?php
        $mariaDBversion = "error";
        try {
            $link = mysqli_connect("homelab-mariadb", getenv('MARIADB_USER'), getenv('MARIADB_PASSWORD'), null);
            if (mysqli_connect_errno()) {
                throw new Exception(mysqli_connect_error());
            } else {
                $mariaDBversion = mysqli_get_server_info($link);
                $result = mysqli_query($link, "select TIME_FORMAT(SEC_TO_TIME(VARIABLE_VALUE ),'%Hh %im')  as uptime from information_schema.GLOBAL_STATUS where VARIABLE_NAME='Uptime';");
                if (!$result) {
                    throw new Exception("Error en la consulta: " . mysqli_error($link));
                }
                $rows = mysqli_fetch_assoc($result);
           }       
        } catch (\Exception $e) {
    ?>
    <div class="alert alert-danger m-2 p-1">
        <?php echo $e->getMessage(); ?>
    </div>
    <?php } ?>

    <div class="container">
        <h1 class="title text-success px-3">
            <i class="icon-docker pe-3"></i> LEMP STACK (<em class="px-3"> <?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?> </em>)
        </h1>
        <small class="muted border d-block px-3 rounded-pill">PHP / Composer / Nginx / MariaDB / Adminer / Redis</small>
        <h2 class="subtitle px-3">
            Your local development environment in Docker
        </h2>
    </div>

    <div class="container-fluid py-2">
        <div class="rounded row border border-primary m-2 p-2 py-3">
            <div class="col-12 col-md">
                <h3 class="title is-3 has-text-centered border-bottom border-primary d-flex py-1">
                    <i class="icon-docker me-2"></i> Environment
                    <small style="font-size: small;" class="badge text-light bg-info rounded ms-auto my-auto"><?php echo $rows['uptime'];?></small>
                </h3>
                <div class="list-group">
                    <span class="list-group-item d-flex justify-content-between align-items-center py-1">
                        <span><i class="icon-nginx me-2"></i> Server:</span>
                        <small class="badge text-light bg-primary rounded-pill px-2">
                            <?= $_SERVER['SERVER_SOFTWARE']; ?>
                        </small>
                    </span>
                    <a href="//php8.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/" target="_blank" class="list-group-item list-group-item-info list-group-item-action d-flex justify-content-between align-items-center py-1">
                        <span><i class="icon-php me-2"></i> PHP8:</span>
                        <small class="badge text-light bg-primary rounded-pill px-2">
                            <?= phpversion(); ?>
                        </small>
                    </a>
                    <a href="//adminer.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/?server=homelab-mariadb&username=<?= getenv('MARIADB_USER'); ?>" target="_blank" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center py-1">
                        <span><i class="icon-mariadb me-2"></i> mariaDB:</span>
                        <small class="badge text-light bg-primary rounded-pill px-2">
                            <?php echo $mariaDBversion; ?>
                        </small>
                    </a>
                </div>
                <a href="//adminer.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/?server=homelab-mariadb&username=<?= getenv('MARIADB_USER'); ?>" target="_blank" class="w-100 mt-2 btn btn-outline-primary p-1">
                    <small class="d-flex justify-content-between align-items-center px-1">
                        <span><i class="icon-mysql-alt me-2"></i> Server:</span>
                        <b class="px-0">
                        homelab-mariadb
                        </b>
                    </small>
                    <small class="d-flex justify-content-between align-items-center px-1">
                        <span><i class="icon-mysql-alt me-2"></i> User:</span>
                        <b class="px-0">
                            <?= getenv('MARIADB_USER'); ?>
                        </b>
                    </small>
                    <small class="d-flex justify-content-between align-items-center px-1">
                        <span><i class="icon-mysql-alt me-2"></i> Password:</span>
                        <b class="px-0">
                        <?= getenv('MARIADB_PASSWORD'); ?>
                        </b>
                    </small>
                </a>
            </div>
            <div class="col-12 col-md-4">
                <h3 class="title has-text-centered border-bottom border-primary d-flex py-1">
                    <i class="icon-google-developers me-2"></i> Quick Links
                </h3>
                <div class="list-group">
                    <a title="php7.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local" target="_blank" class="list-group-item list-group-item-info list-group-item-action p-0 px-2" href="//php7.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/"><i class="icon-php-alt mx-2"></i>php7 -> phpinfo()</a>
                    <a title="php8.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local" target="_blank" class="list-group-item list-group-item-info list-group-item-action p-0 px-2" href="//php8.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/"><i class="icon-php-alt mx-2"></i>php8 -> phpinfo()</a>
                    <a title="adminer.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local" target="_blank" class="list-group-item list-group-item-warning list-group-item-action p-0 px-2" href="//adminer.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/"><i class="icon-database mx-2"></i> adminer</a>
                    <a title="redis.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local" target="_blank" class="list-group-item list-group-item-danger list-group-item-action p-0 px-2" href="//redis.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/"><i class="icon-redis mx-2"></i> redis</a>
                    <a translate="no" title="mailhog.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local" target="_blank" class="list-group-item list-group-item-danger list-group-item-action p-0 px-2" href="//mailhog.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/"><i class=" icon-bomb mx-2"></i> mailhog</a>
                </div>
            </div>
        </div>
        <div class="rounded row border border-success m-2 p-2 py-3">
        <?php
            try {
                if (!$link) {
                    throw new Exception("Fatal Error");
                }
                $result = mysqli_query($link, 'SHOW DATABASES;');
                if (!$result) {
                    throw new Exception("Error en la consulta: " . mysqli_error($link));
                }
                $rows = mysqli_fetch_all($result, MYSQLI_ASSOC);
        ?>
            <div class="col-12 col-md">
                <h3 class="title is-3 has-text-centered border-bottom border-primary d-flex py-1">
                    <i class="icon-mysql me-2"></i> Database List
                    <small class="badge text-light bg-primary ms-auto"><?php echo count($rows);?></small>
                </h3>
                <div class="list-group">
                <?php
                foreach ($rows as $row) { ?>
                    <a target="_blank" translate="no" class="list-group-item list-group-item-action py-1" href="//adminer.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/?server=homelab-mariadb&username=<?= getenv('MARIADB_USER'); ?>&db=<?= $row["Database"]; ?>">
                        <i class="bi bi-database-fill me-2"></i>
                        <?= $row["Database"]; ?>
                    </a>
                <?php }
                ?>
                </div>          
            </div>
        <?php
            mysqli_free_result($result);
            mysqli_close($link);
        } catch (\Exception $e) {
        ?>
        <div class="alert alert-danger">
            <?php echo $e->getMessage(); ?>
        </div>
        <?php }
        if (count($filesDomain) > 3){?>
            <div class="col-12 col-md">
                <h3 class="title is-2 has-text-centered border-bottom border-info d-flex py-1">
                    <i class="icon-nginx me-2"></i> Domain Sites List (<em> .local </em>)
                    <small class="badge text-light bg-info rounded ms-auto"><?php echo count($filesDomain)-3;?></small>
                </h3>
                <div class="list-group">
                    <?php echo listSites($filesDomain, $directoryDomain, "list-group-item list-group-item-action py-1",'','www.');?>
                </div>
            </div>
            <?php }
            if (count($filesSubdomin) > 3){?>
            <div class="col-12 col-md">
                <h3 class="title is-2 has-text-centered border-bottom border-info d-flex py-1">
                    <i class="icon-nginx me-2"></i> SubDomain Sites List (<em> .<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local </em>)
                    <small class="badge text-light bg-info rounded ms-auto"><?php echo count($filesSubdomin)-3;?></small>
                </h3>
                <div class="list-group">
                    <?php echo listSites($filesSubdomin, $directorySubdomin, "list-group-item list-group-item-action py-1",".".strtolower(getenv('COMPOSE_PROJECT_NAME')));?>
                </div>
            </div>
            <?php }?>
        </div>
        <hr class="my-3">
        <div class="container border border-dark rounded p-2">
            <h3 class="text-center py-1 border-bottom"><i class="icon-shell"></i> access to php composer:</h3>
            <ol>
                <li>Open terminal (ej: xterm, gnome-terminal)</li>
                <li>
                    <ul>
                        <li>for PHP7, type this command: <code>docker exec -it homelab-php7 bash</code></li>
                        <li>for PHP8, type this command: <code>docker exec -it homelab-php8 bash</code></li>
                    </ul>
                </li>
                <li>exit: <code>exit</code> or <code>ctrl+d</code> </li>
            </ol>

        </div>
        <hr class="my-3">
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
</body>

<?php
function listSites($files, $directory, $class, $domain = "", $prefix=""){ 
    $sitesLinks = array();
    foreach ($files as $file) {
        if ($file !== '.' && $file !== '..') {
            if (is_dir($directory . $file)) { 
                $type = "nginx-alt";
                if (is_dir($directory . $file.'/build')) { 
                    $type="html";
                }
                if (is_dir($directory . $file.'/public')) { 
                    $type="php";
                }
                $url=$prefix.$file."".$domain;
                $sitesLinks[]="<a translate='no' title='$url.local' target='_blank' class='$class' href='//$url.local' style='min-width: 15vw;'><i class='icon-$type me-2'></i> $file</a>";
            }
        }
    }
    return implode("\n",$sitesLinks);
}
?>
</html>