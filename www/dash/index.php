<?php
include "./inc/head.php";
?>
    <h2 class="mx-4 alert alert-danger p-4 shadow" id="display_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local">
        <b><i class="icon-bomb"></i> The project is inactive.</b>
        <span class="ms-auto">Please start the Docker containers with <code class="px-4"><?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?> up</code> command.</span>
    </h2>
    <?php if ( ! is_null($dbs['error'])){ ?>
    <div class="mx-4 alert alert-danger py-2 shadow">
        <b><i class="<?= $dbs['server']['icon']; ?> me-2"></i> <?= $dbs['server']['name']; ?>:</b> <?php echo $dbs['error']; ?>
    </div>
    <?php } if ( ! is_null($cache['error'])){ ?>
    <div class="mx-4 alert alert-danger py-2 shadow">
        <b><i class="<?= $cache['server']['icon']; ?> me-2"></i> <?= $cache['server']['name']; ?>:</b> <?php echo $cache['error']; ?>
    </div>
    <?php } ?>

    <div class="container-fluid py-2" id="active_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local">
        <div class="row m-1">
            <div class="col-12 mb-3">
                <h3 class="title is-3 has-text-centered border-bottom border-primary d-flex py-1 px-3 shadow">
                    <i class="icon-docker me-2 text-primary"></i> Environment
                    <?php
                        if(!is_null($cache['uptime'])){
                    ?>
                    <a style="font-size: small;" id="cache_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>" target="_blank" class="btn btn-outline-warning btn-sm ms-auto my-auto py-0 <?= $cache['server']['icon']; ?>" href="//redis.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/" data-bs-toggle="tooltip" data-bs-placement="left">redis</a>
                    <?php
                        }
                    ?>
                    <?php
                        if(!is_null($dbs['uptime'])){
                    ?>
                    <a style="font-size: small;" id="database_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>" target="_blank" class="btn btn-outline-primary btn-sm ms-2 my-auto py-0 <?= $dbs['server']['icon']; ?>" href="//adminer.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/" data-bs-toggle="tooltip" data-bs-placement="left">adminer</a>
                    <?php
                        }
                    ?>
                </h3>
            </div>
            <div class="col-12 col-xl">
                <div class="list-group shadow">
                    <span class="list-group-item d-flex justify-content-between align-items-center py-1" data-bs-toggle="tooltip" data-bs-placement="right" data-bs-original-title="Server : <?=$_SERVER['SERVER_SOFTWARE'];?>">
                        <span><i class="icon-nginx me-2"></i> <b>Server :</b></span>
                        <small class="badge text-light bg-primary rounded-pill px-2">
                            <?= $_SERVER['SERVER_SOFTWARE']; ?>
                        </small>
                    </span>
                    <a href="//php8.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/" target="_blank" class="list-group-item list-group-item-info list-group-item-action d-flex justify-content-between align-items-center py-1" data-bs-toggle="tooltip" data-bs-placement="right" data-bs-original-title="PHP8 : <?= phpversion(); ?>">
                        <span><i class="icon-php me-2"></i> <b>PHP8 :</b></span>
                        <small class="badge text-light bg-primary rounded-pill px-2">
                            <?= phpversion(); ?>
                        </small>
                    </a>
                    <?php
                        if(is_null($dbs['error'])){
                    ?>
                    <a href="//adminer.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/?<?= $adminer_server; ?>" target="_blank" class="list-group-item list-group-item-primary list-group-item-action d-flex justify-content-between align-items-center py-1" data-bs-toggle="tooltip" data-bs-placement="right" data-bs-original-title="Database <?= $dbs['server']['name']." : ".$dbs['server']['version']; ?>">
                        <span><i class="<?= $dbs['server']['icon']; ?> me-2"></i> <b><?= $dbs['server']['name']; ?> :</b></span>
                        <small class="badge text-light bg-primary rounded-pill px-2">
                            <?= $dbs['server']['version']; ?>
                        </small>
                    </a>
                    <?php
                        }
                        if(is_null($cache['error'])){
                    ?>
                    <a href="//redis.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/" target="_blank" class="list-group-item list-group-item-warning list-group-item-action d-flex justify-content-between align-items-center py-1" data-bs-toggle="tooltip" data-bs-placement="right" data-bs-original-title="Cache <?= $cache['server']['name']." : ".$cache['server']['version']; ?>">
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
                <a href="//adminer.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/?<?= $adminer_server; ?>"  data-bs-toggle="tooltip" data-bs-placement="right" data-bs-original-title="<?= "Database Connection: ". $dbs['server']['name']." | Server: $database_server | User: $database_user | Password: $database_pass | Port: $database_port"; ?>" target="_blank" class="w-100 mt-3 shadow btn btn-outline-primary p-1">
                    <h5 class="text-light bg-info py-1 mb-1 rounded"><i class="bi bi-database-fill me-2"></i> Database Connection: <b><?= $dbs['server']['name']; ?></b></h5>
                    <small class="d-flex justify-content-between align-items-center px-1">
                        <span><i class="<?= $dbs['server']['icon-alt']; ?> me-2"></i> Server:</span>
                        <b class="px-0">
                        <?= $database_server; ?>
                        </b>
                    </small>
                    <small class="d-flex justify-content-between align-items-center px-1">
                        <span><i class="<?= $dbs['server']['icon-alt']; ?> me-2"></i> User:</span>
                        <b class="px-0">
                        <?= $database_user; ?>
                        </b>
                    </small>
                    <small class="d-flex justify-content-between align-items-center px-1">
                        <span><i class="<?= $dbs['server']['icon-alt']; ?> me-2"></i> Password:</span>
                        <b class="px-0">
                        <?= $database_pass; ?>
                        </b>
                    </small>
                    <small class="d-flex justify-content-between align-items-center px-1">
                        <span><i class="<?= $dbs['server']['icon-alt']; ?> me-2"></i> Port:</span>
                        <b class="px-0">
                        <?= $database_port; ?>
                        </b>
                    </small>
                </a>
                <?php } ?>
                <?php
                    if(is_null($cache['error'])){
                ?>
                <a href="//redis.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/" target="_blank" class="w-100 mt-3 shadow btn btn-outline-warning p-1"  data-bs-toggle="tooltip" data-bs-placement="right" data-bs-original-title="<?= "Cache Connection: ". $cache['server']['name']." | Server: $cache_server | Port: $cache_port"; ?>">
                    <h5 class="text-light bg-danger py-1 mb-1 rounded"><i class="<?= $cache['server']['icon']; ?> me-2"></i> Cache Connection: <b><?= $cache['server']['name']; ?></b></h5>
                    <small class="d-flex justify-content-between align-items-center px-1">
                        <span><i class="<?= $cache['server']['icon']; ?> me-2"></i> Server:</span>
                        <b class="px-0">
                        <?= $cache_server; ?>
                        </b>
                    </small>
                    <small class="d-flex justify-content-between align-items-center px-1">
                        <span><i class="<?= $cache['server']['icon']; ?> me-2"></i> Port:</span>
                        <b class="px-0">
                        <?= $cache_port; ?>
                        </b>
                    </small>
                </a>
                <?php } ?>
            </div>
            <div class="col-12 col-xl-5">

                <div class="list-group shadow mb-3">
                    <span data-bs-toggle="tooltip" data-bs-placement="left" class="list-group-item d-flex justify-content-between align-items-center py-1 border-primary" id="datetime_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_tooltip">
                        <span><i class="icon-php-alt me-2"></i> DateTime :</span>
                        <b class="px-2" id="datetime_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>">-</b>
                    </span>
                </div>

                <h3 class="title has-text-centered border-bottom border-primary d-flex py-1">
                    <i class="icon-google-developers me-2"></i> Quick Links
                </h3>
                <div class="mt-3 list-group shadow">
                    <a translate="no" data-bs-toggle="tooltip" data-bs-placement="left" data-bs-original-title="Manual Homelab" class="list-group-item list-group-item-info list-group-item-action p-1 px-2" href="/manual.php" target="_blank"><i class=" icon-php mx-2"></i> Manual Homelab</a>
                </div>
                <div class="mt-3 list-group shadow">
                    <a name="php7_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local_tooltip" data-bs-toggle="tooltip" data-bs-placement="left" target="_blank" class="list-group-item list-group-item-info list-group-item-action p-1 px-2 d-flex" href="//php7.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/"><i class="icon-php-alt mx-2"></i> PHP7 ➤ phpinfo()<small style="font-size: small;" class="badge text-light bg-primary rounded ms-auto my-auto" name="php7_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local">-</small></a>
                    <a name="php8_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local_tooltip" data-bs-toggle="tooltip" data-bs-placement="left" target="_blank" class="list-group-item list-group-item-info list-group-item-action p-1 px-2 d-flex" href="//php8.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/"><i class="icon-php-alt mx-2"></i> PHP8 ➤ phpinfo()<small style="font-size: small;" class="badge text-light bg-primary rounded ms-auto my-auto" name="php8_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local">-</small></a>
                </div>
                <div class="mt-3 list-group shadow">
                    <a data-bs-toggle="tooltip" data-bs-placement="left" data-bs-original-title="🌐 adminer.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local ➤ Adminer" target="_blank" class="list-group-item list-group-item-primary list-group-item-action p-1 px-2" href="//adminer.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/"><i class="icon-database mx-2"></i> Adminer</a>
                    <a name="redis_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local_tooltip" data-bs-toggle="tooltip" data-bs-placement="left" target="_blank" class="list-group-item list-group-item-warning list-group-item-action p-1 px-2 d-flex" href="//redis.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/"><i class="icon-redis mx-2"></i> Redis<small style="font-size: small;" class="badge text-light bg-warning rounded ms-auto my-auto" name="redis_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local">-</small></a>
                    <a data-bs-toggle="tooltip" data-bs-placement="left" data-bs-original-title="🌐 goaccess.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local ➤ GoAccess LOG" target="_blank" class="list-group-item list-group-item-dark list-group-item-action p-1 px-2" href="//goaccess.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/"><i class="bi bi-journal-text mx-2"></i> GoAccess LOG</a>
                    <a translate="no" data-bs-toggle="tooltip" data-bs-placement="left" data-bs-original-title="🌐 mailhog.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local ➤ MailHog" target="_blank" class="list-group-item list-group-item-info list-group-item-action p-1 px-2" href="//mailhog.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/"><i class=" icon-bomb mx-2"></i> MailHog</a>
                </div>
            </div>
        </div>
        <div class="row my-4 mx-1">
            <?php
                if(is_null($dbs['error'])){
            ?>
            <div class="col-12 col-xl">
                <h5 class="title is-3 has-text-centered border-bottom border-primary d-flex py-1 mb-3">
                    <i class="<?= $dbs['server']['icon']; ?> me-2 text-primary"></i> Database List
                    <small class="badge text-light bg-primary ms-auto"><?php echo count($dbs['database']);?></small>
                </h5>
                <div class="list-group shadow">
                <?php
                foreach ($dbs['database'] as $row) { ?>
                    <a target="_blank" translate="no" class="list-group-item list-group-item-action list-group-item-info py-1" href="//adminer.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/?<?= $adminer_server; ?>&db=<?= $row["Database"]; ?>" data-bs-toggle="tooltip" data-bs-placement="right" data-bs-original-title="<?= "⛁ ".$row["Database"]." ➤ ".$row["Chars"]." ➤ ".$row["Collation"].($row["Comment"]!=""?" ".$row["Comment"]:'').""; ?>">
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
                <h5 class="title is-3 has-text-centered border-bottom border-primary d-flex py-1 mb-3">
                    <i class="<?= $cache['server']['icon']; ?> me-2 text-warning"></i> Cache List
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
            if ($sitesDomain[2] > 0){?>
            <div class="col-12 col-xl">
                <h5 class="title is-2 has-text-centered border-bottom border-info d-flex py-1 mb-3">
                    <i class="text-success icon-nginx me-2"></i> Domain Sites List (<em> .local </em>)
                    <small class="badge text-light bg-info rounded ms-auto"><?php echo $sitesDomain[2];?></small>
                </h5>
                <div class="list-group shadow">
                    <?php echo $sitesDomain[1];?>
                </div>
            </div>
            <?php }
            if ($sitesSubdomain[2] > 0){?>
            <div class="col-12 col-xl">
                <h5 class="title is-2 has-text-centered border-bottom border-info d-flex py-1 mb-3">
                    <i class="text-success icon-nginx me-2"></i> SubDomain Sites List (<em> .<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local </em>)
                    <small class="badge text-light bg-info rounded ms-auto"><?php echo $sitesSubdomain[2];?></small>
                </h5>
                <div class="list-group shadow">
                    <?php echo $sitesSubdomain[1];?>
                </div>
            </div>
            <?php }?>
        </div>
    </div>
    <div class="container-fluid py-2" id="active2_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local">
        <div class="container border border-primary rounded p-2 my-1 shadow">
            <h3 class="text-center py-1 border bg-dark text-light rounded"><i class="icon-shell me-4"></i> access to php composer:</h3>
            <ol>
                <li>Open terminal (ej: xterm, tilix, kitty, etc)</li>
                <li>
                    <ul>
                        <li>for PHP7, type this command: <code>docker exec -it homelab-php7 bash</code> or <code><?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?> php7-usr</code></li>
                        <li>for PHP8, type this command: <code>docker exec -it homelab-php8 bash</code> or <code><?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?> php8-usr</code></li>
                    </ul>
                </li>
                <li>exit: <code>exit</code> or <code>ctrl+d</code> </li>
            </ol>

        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5/dist/js/bootstrap.bundle.min.js" integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI" crossorigin="anonymous"></script>
    <script>
    toggleThemeMenu();
    dataUrl('https://redis.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/',"redis_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local");
    dataUrl('https://php8.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/',"php8_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local");
    dataUrl('https://php7.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/',"php7_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local");
    function recursiveLoop(kkk) {
        dataUptimeUrl('/uptime.php', '<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>');
        setTimeout(recursiveLoop, 15000);
    }
    recursiveLoop();
    const tooltipElements = document.querySelectorAll('[data-bs-toggle="tooltip"]');
    for (const tooltip of tooltipElements) {
        new bootstrap.Tooltip(tooltip); // eslint-disable-line no-new
    }  
    </script>

</body>
</html>