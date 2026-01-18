<?php
include "./inc/head.php";
?>
    <h2 class="mx-4 alert alert-danger p-4 shadow" id="display_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local">
        <b><i class="icon-docker"></i> The project is inactive.</b>
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
                <div class="row m-0">
                <?php
                    if(is_null($dbs['error'])){
                ?>
                <div class="col-12 m-0 col-xxl-6 d-flex">
                <a href="//adminer.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/?<?= $adminer_server; ?>"  data-bs-toggle="tooltip" data-bs-placement="right" data-bs-original-title="<?= "Database Connection: ". $dbs['server']['name']." | Server: $database_server | User: $database_user | Password: $database_pass | Port: $database_port"; ?>" target="_blank" class="w-100 mt-3 shadow btn btn-outline-primary p-1">
                    <h5 class="fs-3 text-light bg-info py-1 mb-1 rounded"><i class="bi bi-database-fill me-2"></i> Database Connection: <b><?= $dbs['server']['name']; ?></b></h5>
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
                </a></div>
                <?php } ?>
                <div class="col-12 m-0 col-xxl-6">
                <?php
                    if(is_null($cache['error'])){
                ?>
                <div class="col-12 p-0 m-0">
                <a href="//redis.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/" target="_blank" class="w-100 mt-3 shadow btn btn-outline-warning p-1"  data-bs-toggle="tooltip" data-bs-placement="right" data-bs-original-title="<?= "Cache Connection: ". $cache['server']['name']." | Server: $cache_server | Port: $cache_port"; ?>">
                    <h5 class="fs-3 text-light bg-danger py-1 mb-1 rounded"><i class="<?= $cache['server']['icon']; ?> me-2"></i> Cache Connection: <b><?= $cache['server']['name']; ?></b></h5>
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
                </a></div>
                <?php } ?>
                <div class="col-12 p-0 m-0">
                <a href="//mailer.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/" target="_blank" class="w-100 mt-3 shadow btn btn-outline-success p-1"  data-bs-toggle="tooltip" data-bs-placement="right" data-bs-original-title="<?= "SMTP SERVER Connection: ". $mailer['server']['name']." | Server: $mailer_server | Port: $mailer_smtp_port"; ?>">
                    <h5 class="fs-3 text-light bg-success py-1 mb-1 rounded"><i class="<?= $mailer['server']['icon']; ?> me-2"></i> SMTP SERVER Connection: <b><?= $mailer['server']['name']; ?></b></h5>
                    <small class="d-flex justify-content-between align-items-center px-1">
                        <span><i class="<?= $mailer['server']['icon']; ?> me-2"></i> Server:</span>
                        <b class="px-0">
                        <?= $mailer_server; ?>
                        </b>
                    </small>
                    <small class="d-flex justify-content-between align-items-center px-1">
                        <span><i class="<?= $mailer['server']['icon']; ?> me-2"></i> Port:</span>
                        <b class="px-0">
                        <?= $mailer_smtp_port; ?>
                        </b>
                    </small>
                </a></div>
                </div>
                </div>
            </div>
            <div class="col-12 col-xl-5">

                <div class="list-group shadow mt-lg-0 mt-3 mb-3">
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
                    <a name="adminer_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local_tooltip" data-bs-toggle="tooltip" data-bs-placement="left" data-bs-original-title="🌐 adminer.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local ➤ Adminer" target="_blank" class="list-group-item list-group-item-primary list-group-item-action p-1 px-2 d-flex" href="//adminer.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/"><i class="icon-database mx-2"></i> Adminer<small style="font-size: small;" class="badge text-light bg-primary rounded ms-auto my-auto" name="adminer_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local">-</small></a>
                    <a name="redis_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local_tooltip" data-bs-toggle="tooltip" data-bs-placement="left" target="_blank" class="list-group-item list-group-item-warning list-group-item-action p-1 px-2 d-flex" href="//redis.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/"><i class="icon-redis mx-2"></i> Redis<small style="font-size: small;" class="badge text-light bg-warning rounded ms-auto my-auto" name="redis_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local">-</small></a>
                    <a data-bs-toggle="tooltip" data-bs-placement="left" data-bs-original-title="🌐 goaccess.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local ➤ GoAccess LOG" target="_blank" class="list-group-item list-group-item-dark list-group-item-action p-1 px-2" href="//goaccess.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/"><i class="bi bi-journal-text mx-2"></i> GoAccess LOG</a>
                    <a name="mailer_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local_tooltip" translate="no" data-bs-toggle="tooltip" data-bs-placement="left" data-bs-original-title="🌐 mailer.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local ➤ SMTP Server" target="_blank" class="list-group-item list-group-item-info list-group-item-action p-1 px-2 d-flex" href="//mailer.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/"><i class="bi bi-envelope-paper-fill mx-2"></i> SMTP Server<small style="font-size: small;" class="badge text-light bg-primary rounded ms-auto my-auto" name="mailer_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local">-</small></a>
                </div>
            </div>
        </div>
        <div class="row my-4 mx-1">
            <div class="col-12 col-xl">
            <?php
                if(is_null($dbs['error'])){
            ?>
            <div class="mb-4">
                <h5 class="title is-3 has-text-centered border-bottom border-primary d-flex py-1 mb-3">
                    <i class="<?= $dbs['server']['icon']; ?> me-2 text-primary"></i> Database List
                    <small class="badge text-light bg-primary ms-auto"><?php echo count($dbs['database']);?></small>
                </h5>
                <div class="list-group shadow">
                <?php
                foreach ($dbs['database'] as $row) { 
                    $dbuser = ($row["Comment"]!=""?trim(explode('--', $row["Comment"])[1]):$database_user);
                    $adminer_server2 = "server=".$database_server."&username=".$dbuser."&password=".$database_pass;
                    ?>
                    <a target="_blank" translate="no" class="list-group-item list-group-item-action list-group-item-info py-1" href="//adminer.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/?<?= $adminer_server2; ?>&db=<?= $row["Database"]; ?>" data-bs-toggle="tooltip" data-bs-placement="right" data-bs-original-title="<?= "⛁ ".$row["Database"]." ➤ $dbuser ➤ ".$row["Chars"]." ➤ ".$row["Collation"].($row["Comment"]!=""?" ➤ ".$row["Comment"]:'').""; ?>">
                        <i class="bi bi-database-fill me-2"></i>
                        <?= $row["Database"]; ?>
                    </a>
                <?php }
                ?>
                </div>
            </div>
            <?php }
            if($cache['counter']>=1){
            ?>
            <div class="mb-4">
                <h5 class="title is-3 has-text-centered border-bottom border-primary d-flex py-1 mb-3">
                    <i class="<?= $cache['server']['icon']; ?> me-2 text-warning"></i> Cache List
                    <small class="badge text-light bg-primary ms-auto"><?php echo $cache['counter'];?></small>
                </h5>
                <div class="list-group shadow">
                <?php
                foreach ($cache['keys'] as $dbV => $row2) {
                    foreach ($row2 as $row) { ?>
                    <span class="list-group-item list-group-item-action list-group-item-info py-1" data-bs-toggle="tooltip" data-bs-placement="left" data-bs-original-title="<?= $dbV.": ".$row; ?>">
                        <i class="bi bi-memory me-2"></i>
                        <?= $dbV.": ".$row; ?>
                    </span>
                <?php }}
                ?>
                </div>
            </div>
            <?php }?>
        </div>
            <?php
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
                        <li>for PHP7, type this command: <code>docker exec -it homelab-php7 bash</code> or <code><?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?> php7 --user</code></li>
                        <li>for PHP8, type this command: <code>docker exec -it homelab-php8 bash</code> or <code><?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?> php8 --user</code></li>
                    </ul>
                </li>
                <li>exit: <code>exit</code> or <code>ctrl+d</code> </li>
            </ol>

        </div>
    </div>
    
    <div class="container-fluid pb-2" id="git_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local">
        <div class="container border border-primary rounded p-2 my-1 shadow">
            <h6 class="text-center py-1 border bg-dark text-light rounded"><i class="icon-git me-4"></i> the latest commit on GitHub:</h6>
            <code class="text-center d-block"><?php echo $objVersion->gitinfo ?? "-"; ?></code>
        </div>
    </div>
    <script>
    function recursiveLoop(kkk) {
        dataUptimeUrl('/uptime.php', '<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>');
        setTimeout(recursiveLoop, <?php echo getenv('TIMEUOT_DASHBOARD'); ?>);
    }
    recursiveLoop();
    </script>
<?php
include "./inc/footer.php";
?>
