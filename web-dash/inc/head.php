<?php
include "./inc/config.php";
include "./inc/libs.php";
include "./inc/dbs.php";
include "./inc/cache.php";
include "./inc/mailer.php";
$funtionsITEMS=[
    ['','',"name='ITEMNODESITEID_tooltip' data-bs-toggle='tooltip' data-bs-placement='right' data-bs-original-title='🌐 ITEMNODESITETITLE ➤ ITEMNODESITETYPE ➤ ITEMNODESITEURLSHORT' data-title='ITEMNODESITETITLE ➤ ITEMNODESITETYPE'"],
    ['<script>listSitesURL(\'ITEMNODESITEID\',\'ITEMNODESITEURL\');</script>','<small style=\'font-size: xx-small;\' class=\'badge text-light bg-primary rounded ms-auto my-auto\' name=\'ITEMNODESITEID\'>-</small>',"name='ITEMNODESITEID_tooltip' data-bs-toggle='tooltip' data-bs-placement='left' data-bs-original-title='🌐 ITEMNODESITETITLE ➤ ITEMNODESITETYPE ➤ ITEMNODESITEURLSHORT' data-title='ITEMNODESITETITLE ➤ ITEMNODESITETYPE'"],
    ['<script>listSitesURL(\'ITEMNODESITEID\',\'ITEMNODESITEURL\');</script>','<small style=\'font-size: xx-small;\' class=\'badge text-light bg-primary rounded ms-auto my-auto\' name=\'ITEMNODESITEID\'>-</small>',"name='ITEMNODESITEID_tooltip' data-bs-toggle='tooltip' data-bs-placement='left' data-bs-original-title='🌐 ITEMNODESITETITLE ➤ ITEMNODESITETYPE ➤ ITEMNODESITEURLSHORT' data-title='ITEMNODESITETITLE ➤ ITEMNODESITETYPE'"]
];
$replaceITEMS=[
    ['ITEMNODESITEID','ITEMNODESITEURL','ITEMNODESITETYPE','ITEMNODESITETITLE','ITEMNODESITEURLSHORT'],
    ['ITEMNODESITEID','ITEMNODESITEURL','ITEMNODESITETYPE','ITEMNODESITETITLE','ITEMNODESITEURLSHORT'],
    ['ITEMNODESITEID','ITEMNODESITEURL','ITEMNODESITETYPE','ITEMNODESITETITLE','ITEMNODESITEURLSHORT']
];
$classITEMS=[
    "dropdown-item",
    "list-group-item list-group-item-action list-group-item-secondary py-1 d-flex", 
    "list-group-item list-group-item-action list-group-item-secondary py-1 d-flex"
];
$typeITEMS=[
    "navbar",
    "gral",
    'group'
];
$sitesDomain = listSitesJSON("domains", $typeITEMS, $classITEMS, $funtionsITEMS, $replaceITEMS);
$sitesSubdomain = listSitesJSON("subdomains", $typeITEMS, $classITEMS, $funtionsITEMS, $replaceITEMS);
$objVersion = json_decode(file_get_contents('version.json'));
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <link rel="icon" href="./favicon.ico" />
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>LEMP STACK -- <?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local </title>
    <link id="theme_bootswatch" rel="stylesheet" href="https://bootswatch.com/5/spacelab/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-mfizz/2.4.1/font-mfizz.min.css" integrity="sha512-Cdvnk1SFWqcb3An6gMyqDRH40Js8qmsWcSK10I2gSifCe2LilaPMsHd6DldEvQ3uIlCb1qdRUrNeAFFleOu4xQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.min.css" integrity="sha256-pdY4ejLKO67E0CM2tbPtq1DJ3VGDVVdqAR6j3ZwdiE4=" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5/dist/js/bootstrap.bundle.min.js" integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI" crossorigin="anonymous"></script>
    <script src="https://<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/files.js" crossorigin="anonymous"></script>
    <style>
        small::before{ margin-right: .5rem;}
        .btn::before{ margin-right: .5rem;}
        .tooltip-inner { max-width: 90vw; font-family: monospace; padding-right: 1rem; padding-left: 1rem; }
        .accordion-button::after { margin-left: 1rem; }
    </style>
</head>

<body style="padding-top: 96px;">
    <nav class="navbar navbar-expand-xl bg-body-tertiary fixed-top shadow">

        <div class="container">
            <a data-bs-toggle="tooltip" data-bs-placement="bottom" data-bs-original-title="LEMP STACK ➤ Compose: <?php echo strtoupper(getenv('COMPOSE_PROJECT_NAME')); ?> ➤ Your local development environment in Docker" href="//www.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local" class="navbar-brand"><i class="me-2 icon-docker"></i> LEMP</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarResponsive">
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a name="php7_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local_tooltip" data-bs-toggle="tooltip" data-bs-placement="bottom" class="nav-link" target="_blank" href="//php7.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/"><i class="me-2 text-info icon-php"></i> PHP7</a>
                    </li>
                    <li class="nav-item">
                        <a name="php8_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local_tooltip" data-bs-toggle="tooltip" data-bs-placement="bottom" class="nav-link" target="_blank" href="//php8.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/"><i class="me-2 text-info icon-php"></i> PHP8</a>
                    </li>
                    <li class="nav-item">
                        <a data-bs-toggle="tooltip" data-bs-placement="bottom" data-bs-original-title="🌐 adminer.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local ➤ Adminer" class="nav-link" target="_blank" href="//adminer.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/"><i class="me-2 text-primary icon-database"></i> Adminer</a>
                    </li>
                    <?php if ($sitesDomain[2] > 1){?>          
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle toggle_tooltip" data-bs-placement="bottom" data-bs-original-title="Domain Sites List ( <?php echo $sitesDomain[2];?> Sites )" data-bs-toggle="dropdown" data-bs-auto-close="true" role="button" aria-haspopup="true" aria-expanded="false" href="#" id="domains"><i class="me-2 text-success icon-nginx"></i> Domain (<?php echo $sitesDomain[2];?>)</a>
                        <div class="dropdown-menu shadow" aria-labelledby="domains">
                            <?php
                            echo $sitesDomain[0]; ?>
                        </div>
                    </li>
                    <?php }
                    if ($sitesSubdomain[2] > 1){?>
                     <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle toggle_tooltip" data-bs-placement="bottom" data-bs-original-title="Subdomain Sites List ( <?php echo $sitesSubdomain[2];?> Sites )" data-bs-toggle="dropdown"  data-bs-auto-close="true" role="button" aria-haspopup="true" aria-expanded="false" href="#" id="subdomains"><i class="me-2 text-success icon-nginx"></i> Subdomain (<?php echo $sitesSubdomain[2];?>)</a>
                        <div class="dropdown-menu shadow" aria-labelledby="subdomains">
                            <?php
                            echo $sitesSubdomain[0]; ?>
                        </div>
                    </li>
                <?php } ?>
                </ul>
                <ul class="navbar-nav ms-xl-auto">
                    <li class="nav-item">
                       <button data-bs-placement="bottom" data-bs-original-title="Additional information about the project." class="nav-link d-flex align-items-center toggle_tooltip" type="button" data-bs-toggle="offcanvas" data-bs-target="#offcanvasExtraInfo" aria-controls="offcanvasExtraInfo">
                            <i class="bi bi-layout-text-window"></i>
                       </button>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle d-flex align-items-center toggle_tooltip" data-bs-original-title="Toggle theme" href="#" id="theme-menu" aria-expanded="false" data-bs-toggle="dropdown"  data-bs-auto-close="true" role="button" aria-haspopup="true" aria-expanded="false" data-bs-display="static" aria-label="Toggle theme">
                          <i class="bi bi-sun-fill"></i>
                        </a>
                        <ul class="dropdown-menu shadow dropdown-menu-end">
                          <li>
                            <button type="button" class="dropdown-item d-flex align-items-center" data-bs-theme-style="bi-sun-fill" data-bs-theme-value="light" aria-pressed="false" data-bs-toggle="tooltip" data-bs-placement='right' data-bs-original-title="Toggle theme ➤ LIGHT">
                              <i class="bi bi-sun-fill"></i><span class="ms-4">Light</span>
                            </button>
                          </li>
                          <li>
                            <button type="button" class="dropdown-item d-flex align-items-center" data-bs-theme-style="bi-moon-stars-fill" data-bs-theme-value="dark" data-bs-toggle="tooltip" data-bs-placement='right' data-bs-original-title="Toggle theme ➤ DARK" aria-pressed="true">
                              <i class="bi bi-moon-stars-fill"></i><span class="ms-4">Dark</span>
                            </button>
                          </li>
                        </ul>
                      </li>
                </ul>
            </div>
        </div>
    </nav>
    <div class="container" data-bs-toggle="tooltip" data-bs-placement="top" data-bs-original-title="LEMP STACK ➤ Compose: <?php echo strtoupper(getenv('COMPOSE_PROJECT_NAME')); ?> ➤ Your local development environment in Docker">
        <h1 class="title text-success px-3 d-flex">
            <i class="icon-docker pe-1"></i> <b>LEMP STACK</b> <small class="ms-auto">( Compose: <em class="px-3"> <?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?> </em>)</small>
        </h1>
        <small class="muted border border-secondary d-block px-3 rounded-pill shadow text-center">PHP / Nginx / MariaDB / Adminer / Valkey / Composer / Supervisor / GoAccess / SMTP Server</small>
        <h2 class="subtitle p-3">
            Your local development environment in Docker
        </h2>
    </div>
