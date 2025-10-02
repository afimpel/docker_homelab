<?php
include "./config.php";
include "./libs.php";
include "./dbs.php";
include "./cache.php";

$dateTime = new DateTime('now');
errorLogger(["COMPOSE" => strtoupper(getenv('COMPOSE_PROJECT_NAME')), "SERVER" => $_SERVER['SERVER_SOFTWARE'], 'PHP' => phpversion()], true);
errorLogger($dbs);

// Ruta del directorio a listar
$directorySubdomain = '../subdomains/';
$directoryDomain = '../domains/';
$filesSubdomain = scandir($directorySubdomain);
$filesDomain = scandir($directoryDomain);
$sitesSubdomain = [];
$sitesDomain = [];
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <link rel="icon" href="./favicon.ico" />
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>LEMP STACK -- <?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local </title>
    <link rel="stylesheet" href="https://bootswatch.com/5/spacelab/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-mfizz/2.4.1/font-mfizz.min.css" integrity="sha512-Cdvnk1SFWqcb3An6gMyqDRH40Js8qmsWcSK10I2gSifCe2LilaPMsHd6DldEvQ3uIlCb1qdRUrNeAFFleOu4xQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>

<body style="padding-top: 96px;">
    <nav class="navbar navbar-expand-xl navbar-dark bg-dark fixed-top shadow">

        <div class="container">
            <a href="//www.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local" class="navbar-brand"><i class="me-2 icon-docker"></i> LEMP</a>
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
                        <div class="dropdown-menu shadow" aria-labelledby="domains">
                            <?php
                            $sitesDomain = listSites($filesDomain, $directoryDomain, ["dropdown-item", "list-group-item list-group-item-action list-group-item-secondary py-1"], '', 'www.');
                            echo $sitesDomain[0]; ?>
                        </div>
                    </li>
                    <?php }
                    if (count($filesSubdomain) > 3){?>
                     <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" data-bs-toggle="dropdown" href="#" id="subdomains"><i class="me-2 icon-ghost"></i> SubDomain (<?php echo count($filesSubdomain)-3;?>)</a>
                        <div class="dropdown-menu shadow" aria-labelledby="subdomains">
                            <?php
                            $sitesSubdomain = listSites($filesSubdomain, $directorySubdomain, ["dropdown-item", "list-group-item list-group-item-action list-group-item-secondary py-1"],".".strtolower(getenv('COMPOSE_PROJECT_NAME')));
                            echo $sitesSubdomain[0]; ?>
                        </div>
                    </li>
                <?php } ?>
                </ul>
                <ul class="navbar-nav ms-xl-auto">
                    <li class="nav-item">
                        <a target="_blank" rel="noopener" class="nav-link" href="https://github.com/afimpel/docker_homelab"><i class="bi bi-github"></i> GitHub</a>
                    </li>
                    <li class="nav-item">
                        <a target="_blank" rel="noopener" class="nav-link" href="https://twitter.com/afimpel"><i class="bi bi-twitter"></i> Twitter</a>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" id="theme-menu" aria-expanded="false" data-bs-toggle="dropdown" data-bs-display="static" aria-label="Toggle theme">
                          <i class="bi bi-sun-fill"></i>
                        </a>
                        <ul class="dropdown-menu shadow dropdown-menu-end">
                          <li>
                            <button type="button" class="dropdown-item d-flex align-items-center" data-bs-theme-style="bi-sun-fill" data-bs-theme-value="light" aria-pressed="false">
                              <i class="bi bi-sun-fill"></i><span class="ms-2">Light</span>
                            </button>
                          </li>
                          <li>
                            <button type="button" class="dropdown-item d-flex align-items-center" data-bs-theme-style="bi-moon-stars-fill" data-bs-theme-value="dark" aria-pressed="true">
                              <i class="bi bi-moon-stars-fill"></i><span class="ms-2">Dark</span>
                            </button>
                          </li>
                        </ul>
                      </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container">
        <h1 class="title text-success px-3 d-flex">
            <i class="icon-docker pe-1"></i> <b>LEMP STACK</b> <small class="ms-auto">( Compose: <em class="px-3"> <?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?> </em>)</small>
        </h1>
        <small class="muted border border-secondary d-block px-3 rounded-pill shadow text-center">PHP / Nginx / MariaDB / Adminer / Valkey / Composer / Supervisor</small>
        <h2 class="subtitle p-3">
            Your local development environment in Docker
        </h2>
    </div>

    <?php if ( ! is_null($dbs['error'])){ ?>
    <div class="mx-4 alert alert-danger py-2 shadow">
        <b><i class="<?= $dbs['server']['icon']; ?> me-2"></i> <?= $dbs['server']['name']; ?>:</b> <?php echo $dbs['error']; ?>
    </div>
    <?php } ?>
    <?php if ( ! is_null($cache['error'])){ ?>
    <div class="mx-4 alert alert-danger py-2 shadow">
        <b><i class="<?= $cache['server']['icon']; ?> me-2"></i> <?= $cache['server']['name']; ?>:</b> <?php echo $cache['error']; ?>
    </div>
    <?php } ?>

    <div class="container-fluid py-2">
        <div class="row m-1">
            <div class="col-12 col-xl">
                <h3 class="title is-3 has-text-centered border-bottom border-primary d-flex py-1">
                    <i class="icon-docker me-2"></i> Environment
                    <?php
                        if(!is_null($cache['uptime'])){
                    ?>
                    <small style="font-size: small;" class="badge text-light bg-warning rounded ms-auto my-auto"><i class="<?= $cache['server']['icon']; ?> me-2"></i> <?php echo $cache['uptime'];?></small>
                    <?php
                        }
                    ?>
                    <?php
                        if(!is_null($dbs['uptime'])){
                    ?>
                    <small style="font-size: small;" class="badge text-light bg-info rounded ms-2 my-auto"><i class="<?= $dbs['server']['icon']; ?> me-2"></i> <?php echo $dbs['uptime'];?></small>
                    <?php
                        }
                    ?>
                </h3>
                <div class="list-group shadow">
                    <span class="list-group-item d-flex justify-content-between align-items-center py-1">
                        <span><i class="icon-nginx me-2"></i> <b>Server :</b></span>
                        <small class="badge text-light bg-primary rounded-pill px-2">
                            <?= $_SERVER['SERVER_SOFTWARE']; ?>
                        </small>
                    </span>
                    <a href="//php8.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/" target="_blank" class="list-group-item list-group-item-info list-group-item-action d-flex justify-content-between align-items-center py-1">
                        <span><i class="icon-php me-2"></i> <b>PHP8 :</b></span>
                        <small class="badge text-light bg-primary rounded-pill px-2">
                            <?= phpversion(); ?>
                        </small>
                    </a>
                    <?php
                        if(is_null($dbs['error'])){
                    ?>
                    <a href="//adminer.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/?<?= $adminer_server; ?>" target="_blank" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center py-1">
                        <span><i class="<?= $dbs['server']['icon']; ?> me-2"></i> <b><?= $dbs['server']['name']; ?> :</b></span>
                        <small class="badge text-light bg-primary rounded-pill px-2">
                            <?= $dbs['server']['version']; ?>
                        </small>
                    </a>
                    <?php
                        }
                        if(is_null($cache['error'])){
                    ?>
                    <a href="//redis.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/" target="_blank" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center py-1">
                        <span><i class="<?= $cache['server']['icon']; ?> me-2"></i> <b><?= $cache['server']['name']; ?> :</b></span>
                        <small class="badge text-light bg-primary rounded-pill px-2">
                            <?= $cache['server']['version']; ?>
                        </small>
                    </a>
                    <?php } ?>
                </div>
                <?php
                    if(is_null($dbs['error'])){
                ?>
                <a href="//adminer.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/?<?= $adminer_server; ?>" target="_blank" class="w-100 mt-3 shadow btn btn-outline-primary p-1">
                    <h5 class="text-light bg-primary py-1 mb-1 rounded"><i class="bi bi-database-fill me-2"></i> Database Connection: <b><?= $dbs['server']['name']; ?></b></h5>
                    <small class="d-flex justify-content-between align-items-center px-1">
                        <span><i class="<?= $dbs['server']['icon-alt']; ?> me-2"></i> Server:</span>
                        <b class="px-0">
                        <?= $datebase_server; ?>
                        </b>
                    </small>
                    <small class="d-flex justify-content-between align-items-center px-1">
                        <span><i class="<?= $dbs['server']['icon-alt']; ?> me-2"></i> User:</span>
                        <b class="px-0">
                        <?= $datebase_user; ?>
                        </b>
                    </small>
                    <small class="d-flex justify-content-between align-items-center px-1">
                        <span><i class="<?= $dbs['server']['icon-alt']; ?> me-2"></i> Password:</span>
                        <b class="px-0">
                        <?= $datebase_pass; ?>
                        </b>
                    </small>
                    <small class="d-flex justify-content-between align-items-center px-1">
                        <span><i class="<?= $dbs['server']['icon-alt']; ?> me-2"></i> Port:</span>
                        <b class="px-0">
                        <?= $datebase_port; ?>
                        </b>
                    </small>
                </a>
                <?php } ?>
            </div>
            <div class="col-12 col-xl-5">

                <div class="list-group shadow mb-2">
                    <span class="list-group-item d-flex justify-content-between align-items-center py-1">
                        <span><i class="icon-php-alt me-2"></i> DateTime :</span>
                        <b class="px-2">
                            <?php 
                                $dateTime->setTimezone(new DateTimeZone($_ENV['TZ']));
                                echo $dateTime->format('r');
                            ?>
                        </b>
                    </span>
                </div>

                <h3 class="title has-text-centered border-bottom border-primary d-flex py-1">
                    <i class="icon-google-developers me-2"></i> Quick Links
                </h3>
                <div class="list-group shadow">
                    <a title="php7.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local" target="_blank" class="list-group-item list-group-item-info list-group-item-action p-1 px-2 d-flex" href="//php7.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/"><i class="icon-php-alt mx-2"></i>php7 -> phpinfo()<small style="font-size: small;" class="badge text-light bg-info rounded ms-auto my-auto" id="php7_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local">dd</small></a>
                    <a title="php8.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local" target="_blank" class="list-group-item list-group-item-info list-group-item-action p-1 px-2 d-flex" href="//php8.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/"><i class="icon-php-alt mx-2"></i>php8 -> phpinfo()<small style="font-size: small;" class="badge text-light bg-info rounded ms-auto my-auto" id="php8_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local">dd</small></a>
                    <a title="adminer.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local" target="_blank" class="list-group-item list-group-item-warning list-group-item-action p-1 px-2" href="//adminer.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/"><i class="icon-database mx-2"></i> adminer</a>
                    <a title="redis.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local" target="_blank" class="list-group-item list-group-item-danger list-group-item-action p-1 px-2" href="//redis.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/"><i class="icon-redis mx-2"></i> redis</a>
                    <a translate="no" title="mailhog.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local" target="_blank" class="list-group-item list-group-item-danger list-group-item-action p-1 px-2" href="//mailhog.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/"><i class=" icon-bomb mx-2"></i> mailhog</a>
                </div>
            </div>
        </div>
        <div class="row my-4 mx-1">
            <?php
                if(is_null($dbs['error'])){
            ?>
            <div class="col-12 col-xl">
                <h5 class="title is-3 has-text-centered border-bottom border-primary d-flex py-1">
                    <i class="<?= $dbs['server']['icon']; ?> me-2"></i> Database List
                    <small class="badge text-light bg-primary ms-auto"><?php echo count($dbs['database']);?></small>
                </h5>
                <div class="list-group shadow">
                <?php
                foreach ($dbs['database'] as $row) { ?>
                    <a target="_blank" translate="no" class="list-group-item list-group-item-action list-group-item-info py-1" href="//adminer.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/?<?= $adminer_server; ?>&db=<?= $row["Database"]; ?>" title="<?= $row["Database"]." ( ".$row["Collation"].($row["Comment"]!=""?' --- '.$row["Comment"]:'')." )"; ?>">
                        <i class="bi bi-database-fill me-2"></i>
                        <?= $row["Database"]; ?>
                    </a>
                <?php }
                ?>
                </div>
            </div>
            <?php }
            if(count($cache['keys'])>=1){
            ?>
            <div class="col-12 col-xl">
                <h5 class="title is-3 has-text-centered border-bottom border-primary d-flex py-1">
                    <i class="<?= $cache['server']['icon']; ?> me-2"></i> Cache List
                    <small class="badge text-light bg-primary ms-auto"><?php echo count($cache['keys']);?></small>
                </h5>
                <div class="list-group shadow">
                <?php
                foreach ($cache['keys'] as $row) { ?>
                    <span class="list-group-item list-group-item-action list-group-item-info py-1" title="<?= $row; ?>">
                        <i class="bi bi-memory me-2"></i>
                        <?= $row; ?>
                    </span>
                <?php }
                ?>
                </div>
            </div>
            <?php }
            if (count($filesDomain) > 3){?>
            <div class="col-12 col-xl">
                <h5 class="title is-2 has-text-centered border-bottom border-info d-flex py-1">
                    <i class="icon-nginx me-2"></i> Domain Sites List (<em> .local </em>)
                    <small class="badge text-light bg-info rounded ms-auto"><?php echo count($filesDomain)-3;?></small>
                </h5>
                <div class="list-group shadow">
                    <?php echo $sitesDomain[1];?>
                </div>
            </div>
            <?php }
            if (count($filesSubdomain) > 3){?>
            <div class="col-12 col-xl">
                <h5 class="title is-2 has-text-centered border-bottom border-info d-flex py-1">
                    <i class="icon-nginx me-2"></i> SubDomain Sites List (<em> .<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local </em>)
                    <small class="badge text-light bg-info rounded ms-auto"><?php echo count($filesSubdomain)-3;?></small>
                </h5>
                <div class="list-group shadow">
                    <?php echo $sitesSubdomain[1];?>
                </div>
            </div>
            <?php }?>
        </div>
        <div class="container border border-secondary rounded p-2 my-2 shadow">
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
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5/dist/js/bootstrap.bundle.min.js" integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI" crossorigin="anonymous"></script>
    <script>
    function toggleThemeMenu() {
        let themeMenu = document.querySelector('#theme-menu');
        var bsTheme = localStorage.getItem("bsTheme");
        let prevCss = "bi-sun-fill";
        if (bsTheme){
            document.documentElement.setAttribute('data-bs-theme', bsTheme);
            if(bsTheme == "dark"){
                themeMenu.children[0].classList.replace(prevCss,'bi-moon-stars-fill');
            }
        }
        if (!themeMenu) return;

        document.querySelectorAll('[data-bs-theme-value]').forEach(value => {
            value.addEventListener('click', () => {
                const theme = value.getAttribute('data-bs-theme-value');
                const themeCss = value.getAttribute('data-bs-theme-style');
                themeMenu.children[0].classList.replace(prevCss,themeCss);
                localStorage.setItem("bsTheme", theme);
                prevCss = themeCss;
                document.documentElement.setAttribute('data-bs-theme', theme);
            });
        });
    }
    toggleThemeMenu();
async function obtenerTituloDeUrl(url, idAttr) {
  try {
    const response = await fetch(url);
    if (!response.ok) {
      console.error(`Error al obtener la URL: ${response.status} ${response.statusText}`);
      return null;
    }
    const htmlText = await response.text();
    const parser = new DOMParser();
    const doc = parser.parseFromString(htmlText, 'text/html');
    const title = doc.title;
    document.getElementById(idAttr).innerHTML = title;
    return title || null;

  } catch (error) {
    console.error(`Ocurrió un error al procesar la URL '${url}':`, error);
    return null;
  }
}
function dataUrl(url,id) {
  obtenerTituloDeUrl(url,id).then(title => {
    if (title) {
      console.log(`php7: "${title}"`);
    } else {
      console.log('No se pudo obtener el título de la URL inexistente (esperado).');
    }
  });

}

dataUrl('https://php8.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/',"php8_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local");

// Ejemplo 3: URL que probablemente no existe o da error
dataUrl('https://php7.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/',"php7_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local");
    </script>

</body>
</html>