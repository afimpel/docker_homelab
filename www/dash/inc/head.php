<?php
include "./config.php";
include "./libs.php";
include "./dbs.php";
include "./cache.php";
$funtionsITEMS=[['','',"name='ITEMNODESITEID_tooltip' data-bs-toggle='tooltip' data-bs-placement='right' data-bs-original-title='🌐 ITEMNODESITETITLE ➤ ITEMNODESITETYPE ➤ ITEMNODESITEURLSHORT' data-title='ITEMNODESITETITLE ➤ ITEMNODESITETYPE'"], ['<script>listSitesURL(\'ITEMNODESITEID\',\'ITEMNODESITEURL\');</script>','<small style=\'font-size: xx-small;\' class=\'badge text-light bg-primary rounded ms-auto my-auto\' name=\'ITEMNODESITEID\'>-</small>',"name='ITEMNODESITEID_tooltip' data-bs-toggle='tooltip' data-bs-placement='left' data-bs-original-title='🌐 ITEMNODESITETITLE ➤ ITEMNODESITETYPE ➤ ITEMNODESITEURLSHORT' data-title='ITEMNODESITETITLE ➤ ITEMNODESITETYPE'"]];
$replaceITEMS=[['ITEMNODESITEID','ITEMNODESITEURL','ITEMNODESITETYPE','ITEMNODESITETITLE','ITEMNODESITEURLSHORT'],['ITEMNODESITEID','ITEMNODESITEURL','ITEMNODESITETYPE','ITEMNODESITETITLE','ITEMNODESITEURLSHORT']];
$classITEMS=["dropdown-item", "list-group-item list-group-item-action list-group-item-secondary py-1 d-flex"];
$sitesDomain = listSitesJSON("domains", $classITEMS, $funtionsITEMS, $replaceITEMS);
$sitesSubdomain = listSitesJSON("subdomains", $classITEMS, $funtionsITEMS, $replaceITEMS);
$objVersion = json_decode(file_get_contents('version.json'));
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
    <script src="https://<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/files.js" crossorigin="anonymous"></script>
    <style>
        small::before{ margin-right: .5rem;}
        .btn::before{ margin-right: .5rem;}
        .tooltip-inner { min-width: 30rem; font-family: monospace;}

    </style>
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
                        <a name="php7_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local_tooltip" data-bs-toggle="tooltip" data-bs-placement="bottom" class="nav-link" target="_blank" href="//php7.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/"><i class="me-2 icon-php"></i> PHP7</a>
                    </li>
                    <li class="nav-item">
                        <a name="php8_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local_tooltip" data-bs-toggle="tooltip" data-bs-placement="bottom" class="nav-link" target="_blank" href="//php8.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/"><i class="me-2 icon-php"></i> PHP8</a>
                    </li>
                    <li class="nav-item">
                        <a data-bs-toggle="tooltip" data-bs-placement="bottom" data-bs-original-title="🌐 adminer.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local ➤ Adminer" class="nav-link" target="_blank" href="//adminer.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/"><i class="me-2 icon-database"></i> Adminer</a>
                    </li>
                    <?php if ($sitesDomain[2] > 1){?>          
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" data-bs-toggle="dropdown" href="#" id="domains"><i class="me-2 icon-ghost"></i> Domain (<?php echo $sitesDomain[2];?>)</a>
                        <div class="dropdown-menu shadow" aria-labelledby="domains">
                            <?php
                            echo $sitesDomain[0]; ?>
                        </div>
                    </li>
                    <?php }
                    if ($sitesSubdomain[2] > 1){?>
                     <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" data-bs-toggle="dropdown" href="#" id="subdomains"><i class="me-2 icon-ghost"></i> SubDomain (<?php echo $sitesSubdomain[2];?>)</a>
                        <div class="dropdown-menu shadow" aria-labelledby="subdomains">
                            <?php
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
        <small class="muted border border-secondary d-block px-3 rounded-pill shadow text-center">PHP / Nginx / MariaDB / Adminer / Valkey / Composer / Supervisor / GoAccess</small>
        <h2 class="subtitle p-3">
            Your local development environment in Docker
        </h2>
    </div>
