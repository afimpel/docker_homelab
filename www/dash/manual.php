<?php
include "./inc/head.php";
$jsonString = file_get_contents('json-help.json');
$objVersion = json_decode(file_get_contents('version.json'));
$changeArrayOrigin = array(
    "COMPOSE_PROJECT_NAME",
    "versionPHP7", 
    "versionPHP8", 
    "USERNAME",
    "composerVersion7", 
    "composerVersion8",
    "docker_version",
    "docker_compose_version"
);
$changeArrayEND = array(
    strtolower(getenv('COMPOSE_PROJECT_NAME')), 
    $objVersion->version->php7, 
    $objVersion->version->php8, 
    $objVersion->username, 
    $objVersion->version->composer7, 
    $objVersion->version->composer8,
    $objVersion->version->docker,
    $objVersion->version->dockerCompose
);
$jsonStringReplace = str_replace($changeArrayOrigin, $changeArrayEND, $jsonString);

$objHelp = json_decode($jsonStringReplace);

function filterObjectsByTag(array $objects, string $tagToFind, string $tagPropertyName = 'tags'): array
{
    $filteredObjects = [];
    foreach ($objects as $object) {
        if (property_exists($object, $tagPropertyName) && is_array($object->$tagPropertyName)) {
            if (in_array($tagToFind, $object->$tagPropertyName, true) && in_array($object->mode, ['on','both'], true)) {
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
                            if ( 
                                in_array( $value->mode, ['off'], true ) || 
                                in_array( $value->checkfile, $objVersion->checkfile, true ) 
                            ){
                                continue;
                            }
                            $active = ($value->href == $dataTAG) ? ' active' : '';
                    ?>
                    <a href="manual.php?tags=<?= $value->href; ?>" class="list-group-item list-group-item-info list-group-item-action d-flex justify-content-between align-items-center py-1<?php echo $active; ?>"  data-bs-toggle="tooltip" data-bs-placement="right" data-bs-original-title="<?php echo $objHelp->runner." ".$command." ".$key ?> ➤ <?= $value->description; ?>">
                        <span>
                            <i class="icon-script-alt me-2"></i>
                            <b><?php echo $objHelp->runner." ".$command." ".$key ?></b>
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
                    <div class="border border-primary rounded p-2 m-4 shadow">
                        <h3 class="text-center py-1 border bg-dark text-light rounded"><i class="icon-shell me-4"></i> USE:</h3>
                        <ol>
                            <li>Open terminal (ej: xterm, tilix, kitty, etc)</li>
                            <li>copy and paste the following command. ( ex: <code><?php echo $objHelp->runner." status" ?></code>)</li>
                            <li>exit: <code>exit</code> or <code>ctrl+d</code> </li>
                        </ol>
                    </div>
                    
                    <hr class="my-2 mx-4">

                    <figure class="text-center">
                        <blockquote class="blockquote">
                            <p class="mb-0">Commands are listed here:</p>
                        </blockquote>
                    </figure>
                    <?php
                        $objHelp0001 = filterObjectsByTag($objHelp->commands, $dataTAG);
                        foreach ($objHelp0001 as $key00 => $value00) {
                            $command = $value00->command;
                            $description = $value00->description;
                            $title = $value00->title;
                            $href = $value00->href;
                            if ( 
                                in_array( $value00->mode,['off'],true ) || 
                                in_array( $value00->checkfile,$objVersion->checkfile,true ) 
                            ){
                                continue;
                            }
                    ?>
                    <a href="manual.php?tags=<?= $href; ?>" class="mx-4 mt-4 shadow btn btn-outline-secondary text-decoration-none fs-4 title is-3 has-text-centered d-flex py-1">
                        <span class="pe-4 me-auto"><i class="icon-script-alt me-2"></i> <?=$title; ?>: </span>
                        <small class="small rounded-pill px-2" style="font-size: small;"> <?=$description; ?> </small>
                    </a>
                    <div class="mx-4 my-2 list-group shadow">
                    <?php
                            foreach ($value00->options as $key => $value) {
                                if ( 
                                    in_array( $value->mode,['off'],true ) || 
                                    in_array( $value->checkfile,$objVersion->checkfile,true ) 
                                ){
                                    continue;
                                }
                    ?>
                    <span class="list-group-item list-group-item-info list-group-item-action d-flex justify-content-between align-items-center py-1" data-bs-toggle="tooltip" data-bs-placement="top" data-bs-original-title="<?=$title; ?> ➤ <?php echo $objHelp->runner." ".$command." ".$key ?> ➤ <?= $value->description; ?>">
                        <b>
                            <i class="icon-shell me-2"></i>
                            <code><?php echo $objHelp->runner." ".$command." ".$key ?></code>
                        </b>
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
    const codes = document.querySelectorAll('code');
    dataUrl('https://redis.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/',"redis_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local");
    dataUrl('https://php8.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/',"php8_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local");
    dataUrl('https://php7.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/',"php7_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local");
    const tooltipElements = document.querySelectorAll('[data-bs-toggle="tooltip"]');
    for (const tooltip of tooltipElements) {
        new bootstrap.Tooltip(tooltip); // eslint-disable-line no-new
    }  

  codes.forEach(code => {
    code.style.cursor = 'pointer';
    const parent = code.parentElement.parentElement;
    parent.style.transition = 'all 0.6s ease';

    code.addEventListener('click', async () => {
        const texto = code.innerText;
        try {
            await navigator.clipboard.writeText(texto);
            
            const originalBg = parent.style.backgroundColor;
            const originalColor = parent.style.color;
            const originalCodeTextBg = code.style.color;

            parent.style.backgroundColor = '#333';
            parent.style.color = '#fff';
            code.style.color = 'silver';
            console.log('Copy :', texto);

            setTimeout(() => {
                parent.style.backgroundColor = originalBg;
                parent.style.color = originalColor;
                code.style.color = originalCodeTextBg;
            }, 1500);
        } catch (err) {
            console.error('Copy ERROR:', err);
        }
    });
  });
    </script>
</body>
</html>