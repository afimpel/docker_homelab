<?php
include "./config.php";
include "./libs.php";
include "./dbs.php";
include "./cache.php";

$dateTime = new DateTime('now');
// Ruta del directorio a listar
$directorySubdomain = '../subdomains/';
$directoryDomain = '../domains/';
$filesSubdomain = scandir($directorySubdomain);
$filesDomain = scandir($directoryDomain);
$sitesSubdomain = [];
$sitesDomain = [];
$jsonString = file_get_contents('json-help.json');
$objVersion = json_decode(file_get_contents('version.json'));
$changeArrayOrigin = array(
    "COMPOSE_PROJECT_NAME",
    "versionPHP7", 
    "versionPHP8", 
    "USERNAME",
    "composerVersion7", 
    "composerVersion8" 
);
$changeArrayEND = array(
    strtolower(getenv('COMPOSE_PROJECT_NAME')), 
    $objVersion->version->php7, 
    $objVersion->version->php8, 
    $objVersion->username, 
    $objVersion->version->composer7, 
    $objVersion->version->composer8
);
$jsonStringReplace = str_replace($changeArrayOrigin, $changeArrayEND, $jsonString);

$objHelp = json_decode($jsonStringReplace);

function filterObjectsByTag(array $objects, string $tagToFind, string $tagPropertyName = 'tags'): array
{
    $filteredObjects = [];
    foreach ($objects as $object) {
        if (property_exists($object, $tagPropertyName) && is_array($object->$tagPropertyName)) {
            if (in_array($tagToFind, $object->$tagPropertyName, true)) {
                $filteredObjects[] = $object;
            }
        }
    }
    return $filteredObjects;
}
$dataTAG = "all";
if (isset($_GET['tags'])) {
    $dataTAG=$_GET['tags'];
}

$objHelp0000 = filterObjectsByTag($objHelp->commands,'list');
$command = $objHelp0000[0]->command;
$title = $objHelp0000[0]->title;
$description = $objHelp0000[0]->description;

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
        <small class="muted border border-secondary d-block px-3 rounded-pill shadow text-center">PHP / Nginx / MariaDB / Adminer / Valkey / Composer / Supervisor / GoAccess</small>
        <h2 class="subtitle p-3">
            Your local development environment in Docker
        </h2>
    </div>
    <div class="container-fluid py-2">
        <div class="row m-1">
            <div class="col-12 mb-3">
                <h3 class="title is-3 has-text-centered border-bottom border-primary d-flex p-1 shadow" >
                    <span><i class="icon-docker me-2"></i> Manual Homelab</span>
                    <a href="./" style="font-size: small;" class="me-2 ms-auto my-auto px-4 py-0 shadow btn btn-outline-secondary btn-sm">back to HOME</a>
                </h3>
            </div>
            <div class="col-12 col-xl">
                <div class="list-group shadow">
                    <a href="manual.php" class="list-group-item list-group-item-info list-group-item-action d-flex justify-content-between align-items-center py-1">
                        <span><i class="icon-shell me-2"></i> <b>HOME :</b></span>
                    </a>
                </div>
                <small class="small mx-auto text-center my-2 d-block"><?=$title.": ".$description; ?></small>
                <div class="mt-3 list-group shadow">
                    <?php
                        foreach ($objHelp0000[0]->options as $key => $value) {
                            $active = ($value->href == $dataTAG) ? ' active' : '';
                    ?>
                    <a href="manual.php?tags=<?= $value->href; ?>" class="list-group-item list-group-item-info list-group-item-action d-flex justify-content-between align-items-center py-1<?php echo $active; ?>">
                        <span>
                            <i class="icon-script-alt me-2"></i>
                            <b><?php echo $command." ".$key ?></b>
                        </span>
                        <small class="badge text-light bg-primary rounded-pill px-2">
                            <?= $value->description; ?>
                        </small>
                    </a>
                    <?php
                        }
                    ?>

                </div>



            </div>
            <div class="col-12 col-xl-9">
                <div class="border border-primary rounded p-2 m-0 shadow">
                    <div class="input-group input-group-lg">
                        <span class="input-group-text" id="inputGroup-sizing-lg">Syntax</span>
                        <input class="form-control" type="text" value="<?php echo $objHelp->syntax; ?>" readonly />
                    </div>
                    <hr class="m-2" />
                    <figure class="text-center">
                        <blockquote class="blockquote">
                            <p class="mb-0">All help commands are listed here:</p>
                        </blockquote>
                    </figure>
                    <?php
                        $objHelp0001 = filterObjectsByTag($objHelp->commands, $dataTAG);
                        foreach ($objHelp0001 as $key00 => $value00) {
                            $command = $value00->command;
                            $description = $value00->description;
                            $title = $value00->title;
                            $href = $value00->href;
                    ?>
                    <a href="manual.php?tags=<?= $href; ?>" class="shadow btn btn-outline-secondary text-decoration-none fs-4 title is-3 has-text-centered d-flex py-1">
                        <span class="pe-4 me-auto"><i class="icon-script-alt me-2"></i> <?=$title; ?>: </span>
                        <small class="small rounded-pill px-2" style="font-size: small;"> <?=$description; ?> </small>
                    </a>
                    <div class="my-2 list-group shadow">
                    <?php
                            foreach ($value00->options as $key => $value) {
                    ?>
                    <span class="list-group-item list-group-item-info list-group-item-action d-flex justify-content-between align-items-center py-1">
                        <code>
                            <i class="icon-shell me-2"></i>
                            <b><?php echo $command." ".$key ?></b>
                        </code>
                        <small class="badge text-light bg-primary rounded-pill px-2" style="font-size: small;">
                            <?= $value->description; ?>
                        </small>
                    </span>
                    <?php
                            }
                    ?>
                    </div>
                    <?php
                        }
                    ?>
                </div>
            </div>
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
    </script>

</body>
</html>