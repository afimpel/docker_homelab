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
                        if(!is_null($mailer['uptime'])){
                    ?>
                    <a style="font-size: small;" id="mailer_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>" target="_blank" class="btn btn-outline-info btn-sm ms-auto my-auto py-0 <?= $mailer['server']['icon']; ?>" href="//mailer.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/" data-bs-toggle="tooltip" data-bs-placement="left">mailer</a>
                    <?php
                        }
                    ?>
                    <?php
                        if(!is_null($cache['uptime'])){
                    ?>
                    <a style="font-size: small;" id="cache_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>" target="_blank" class="btn btn-outline-warning btn-sm ms-2 my-auto py-0 <?= $cache['server']['icon']; ?>" href="//redis.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/" data-bs-toggle="tooltip" data-bs-placement="left">redis</a>
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
                    <?php
                        }
                        if(is_null($mailer['error'])){
                    ?>
                    <a href="//mailer.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/" target="_blank" class="list-group-item list-group-item-info list-group-item-action d-flex justify-content-between align-items-center py-1" data-bs-toggle="tooltip" data-bs-placement="right" data-bs-original-title="SMTP <?= $mailer['server']['name']." : ".$mailer['server']['version']; ?>">
                        <span><i class="<?= $mailer['server']['icon']; ?> me-2"></i> <b><?= $mailer['server']['name']; ?> :</b></span>
                        <small class="badge text-light bg-primary rounded-pill px-2">
                            <?= $mailer['server']['version']; ?>
                        </small>
                    </a>
                    <?php } ?>
                </div>
                <div class="row m-0">
                <?php
                    if(is_null($dbs['error'])){
                ?>
                <div class="col-12 m-0 col-xxl-6 d-flex px-0 pe-xxl-2">
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
                <div class="col-12 m-0 col-xxl-6 px-0 ps-xxl-2">
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
                        <span><i class="bi bi-clock me-2"></i> DateTime :</span>
                        <b class="px-2" id="datetime_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>">-</b>
                    </span>
                </div>

                <h3 class="title has-text-centered border-bottom border-primary d-flex py-1">
                    <i class="icon-google-developers me-2"></i> Quick Links
                </h3>
                <div class="mt-3 list-group shadow">
                    <a translate="no" data-bs-toggle="tooltip" data-bs-placement="left" data-bs-original-title="Manual Homelab" class="list-group-item list-group-item-info list-group-item-action p-1 px-2" href="/manual.php" target="_blank"><i class=" icon-php mx-2"></i> Manual Homelab</a>
                    <a translate="no" data-bs-toggle="tooltip" data-bs-placement="left" data-bs-original-title="Git Information" class="list-group-item list-group-item-info list-group-item-action p-1 px-2" href="/git-info.php" target="_blank"><i class="bi bi-git mx-2"></i> Git Information</a>
                </div>
                <div class="mt-3 list-group shadow">
                    <a name="php7_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local_tooltip" data-bs-toggle="tooltip" data-bs-placement="left" target="_blank" class="list-group-item list-group-item-info list-group-item-action p-1 px-2 d-flex" href="//php7.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/"><i class="icon-php-alt mx-2"></i> PHP7 ➤ phpinfo()<small style="font-size: small;" class="badge text-light bg-primary rounded ms-auto my-auto" name="php7_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local">-</small></a>
                    <a name="php8_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local_tooltip" data-bs-toggle="tooltip" data-bs-placement="left" target="_blank" class="list-group-item list-group-item-info list-group-item-action p-1 px-2 d-flex" href="//php8.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/"><i class="icon-php-alt mx-2"></i> PHP8 ➤ phpinfo()<small style="font-size: small;" class="badge text-light bg-primary rounded ms-auto my-auto" name="php8_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local">-</small></a>
                </div>
                <div class="mt-3 list-group shadow">
                    <a name="adminer_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local_tooltip" data-bs-toggle="tooltip" data-bs-placement="left" data-bs-original-title="🌐 adminer.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local ➤ Adminer" target="_blank" class="list-group-item list-group-item-primary list-group-item-action p-1 px-2 d-flex" href="//adminer.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/?<?= $adminer_server; ?>"><i class="icon-database mx-2"></i> Adminer<small style="font-size: small;" class="badge text-light bg-primary rounded ms-auto my-auto" name="adminer_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local">-</small></a>
                    <a name="redis_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local_tooltip" data-bs-toggle="tooltip" data-bs-placement="left" target="_blank" class="list-group-item list-group-item-warning list-group-item-action p-1 px-2 d-flex" href="//redis.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/"><i class="icon-redis mx-2"></i> Redis<small style="font-size: small;" class="badge text-light bg-warning rounded ms-auto my-auto" name="redis_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local">-</small></a>
                    <a data-bs-toggle="tooltip" data-bs-placement="left" data-bs-original-title="🌐 goaccess.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local ➤ GoAccess LOG" target="_blank" class="list-group-item list-group-item-dark list-group-item-action p-1 px-2" href="//goaccess.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/"><i class="bi bi-journal-text mx-2"></i> GoAccess LOG</a>
                    <a name="mailer_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local_tooltip" translate="no" data-bs-toggle="tooltip" data-bs-placement="left" data-bs-original-title="🌐 mailer.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local ➤ SMTP Server" target="_blank" class="list-group-item list-group-item-info list-group-item-action p-1 px-2 d-flex" href="//mailer.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/"><i class="bi bi-envelope-paper-fill mx-2"></i> SMTP Server<small style="font-size: small;" class="badge text-light bg-primary rounded ms-auto my-auto" name="mailer_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local">-</small></a>
                </div>
            </div>
        </div>
        <div class="row my-4 mx-1">
            <?php
            if ($sitesDomain[2] > 0){?>
            <div class="col-12 col-xl">
                <h5 class="title is-2 has-text-centered border-bottom border-info d-flex py-1 mb-3" data-bs-toggle="tooltip" data-bs-placement="bottom" data-bs-original-title="Domain Sites List ( <?php echo $sitesDomain[2];?> Sites )">
                    <i class="text-success icon-nginx me-2"></i> Domain Sites List (<em> .local </em>)
                    <b class="px-3 border border-info rounded ms-auto"><?php echo $sitesDomain[2];?></b>
                </h5>
                <div class="accordion" id="accordionDomain">
                <?php
                foreach ($sitesDomain[3] as $domain => $sites) {?>
                    <div class="accordion-item">
                        
                        <h2 class="accordion-header toggle_tooltip" data-bs-original-title="<?= $domain.' ( '.count($sites).' Sites )'; ?>" id="heading-<?= str_replace([".","-"], "", $domain); ?>">
                            <button class="accordion-button collapsed py-2" type="button" data-bs-toggle="collapse" data-bs-target="#collapse-<?= str_replace([".","-"], "", $domain); ?>" aria-expanded="true" aria-controls="collapse-<?= str_replace([".","-"], "", $domain); ?>">
                                <i class="bi bi-diagram-3-fill me-4" style="margin-bottom: 0.125rem;margin-top: 0.125rem;"></i>
                                <span class="me-auto"><?= $domain; ?></span>
                                <span style="font-size: x-small;" class="small my-auto px-2 ms-auto badge bg-primary"><?php echo count($sites);?></span>
                            </button>
                        </h2>
                        <div id="collapse-<?= str_replace([".","-"], "", $domain); ?>" class="accordion-collapse collapse" aria-labelledby="heading-<?= str_replace([".","-"], "", $domain); ?>" data-bs-parent="#accordionDomain">
                            <div class="accordion-body p-2">
                                <div class="list-group shadow">
                                    <?php echo implode("\n",$sites);?>
                                </div>
                            </div>
                        </div>
                    </div>
                    <?php }
                ?>
                </div>
            </div>
            <?php }
            if ($sitesSubdomain[2] > 0){?>
            <div class="col-12 col-xl">
                <h5 class="title is-2 has-text-centered border-bottom border-info d-flex py-1 mb-3" data-bs-toggle="tooltip" data-bs-placement="bottom" data-bs-original-title="Subdomain Sites List ( <?php echo $sitesSubdomain[2];?> Sites )">
                    <i class="text-success icon-nginx me-2"></i> Subdomain Sites List (<em> .<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local </em>)
                    <b class="px-3 border border-info rounded ms-auto"><?php echo $sitesSubdomain[2];?></b>
                </h5>
                <div class="list-group shadow">
                <?php
                foreach ($sitesSubdomain[3] as $domain => $sites) {?>
                    <?php echo implode("\n",$sites);?>
                    <?php }
                ?>
                </div>
            </div>
            <?php }?>
        </div>
        <div class="row my-4 mx-1">
            <?php
                if(is_null($dbs['error'])){
            ?>
            <div class="mb-4 col">
                <h5 class="title is-3 has-text-centered border-bottom border-primary d-flex py-1 mb-3" data-bs-toggle="tooltip" data-bs-placement="bottom" data-bs-original-title="<?php echo $dbs['server']['name']." ".$dbs['server']['version'] ?> ➤  Database List ( <?php echo count($dbs['database']);?> dbs )">
                    <i class="<?= $dbs['server']['icon']; ?> me-2 text-primary"></i> Database List
                    <b class="px-3 border border-info rounded ms-auto"><?php echo count($dbs['database']);?></b>
                </h5>
                <div class="list-group shadow">
                <?php
                foreach ($dbs['database'] as $row) { 
                    $dbuser = $row['User'];
                    $adminer_server2 = "server=".$database_server."&username=".$dbuser."&password=".$database_pass;
                    ?>
                    <a target="_blank" translate="no" class="list-group-item list-group-item-action list-group-item-info py-2 d-flex" href="//adminer.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/?<?= $adminer_server2; ?>&db=<?= $row["Database"]; ?>" data-bs-toggle="tooltip" data-bs-placement="right" data-bs-original-title="<?= $dbs['server']['name'].": ⛁ ".$row["Database"]." ➤ $dbuser ➤ ".$row["Chars"]." ➤ ".$row["Collation"].($row["Comment"]!=""?" ➤ ".$row["Comment"]:'').""; ?>">
                        <i class="bi bi-database-fill me-2"></i>
                        <?= $row["Database"]; ?>
                        <span style="font-size: x-small;" class="small my-auto px-2 ms-auto badge bg-primary"><?php echo $dbuser;?></span>                    
                    </a>
                <?php }
                ?>
                </div>
            </div>
            <?php }
            ?>
            <div class="mb-4 col" id="cacheList_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_div">
                <h5 class="title is-3 has-text-centered border-bottom border-primary d-flex py-1 mb-3" data-bs-toggle="tooltip" data-bs-placement="bottom" data-bs-original-title=" ">
                    <i class="<?= $cache['server']['icon']; ?> me-2 text-warning"></i> Cache List
                    <b class="px-3 border border-info rounded ms-auto" id="cacheList_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_counter">0</b>
                </h5>
                <span style="display: none;" class="list-group-item list-group-item-action list-group-item-info py-2" id="cacheList_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_clone">
                    <i class="bi bi-memory me-2"></i>
                    <span class="nombre">--</span>
                </span>
                <div class="list-group shadow" id="cacheList_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_rows">
                </div>
            </div>
            <div class="mb-4 col" id="mailsList_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_div">
                <h5 class="title is-3 has-text-centered border-bottom border-primary d-flex py-1 mb-3" data-bs-toggle="tooltip" data-bs-placement="bottom" data-bs-original-title=" ">
                    <i class="<?= $mailer['server']['icon']; ?> me-2 text-info"></i> Mail List
                    <b class="px-3 border border-info rounded ms-auto" id="mailsList_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_counter">0</b>
                </h5>
                <div id="mailsList_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_clone" style="display: none;" class="accordion-item">
                    <h2 class="accordion-header" id="heading-<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>">
                        <button class="accordion-button collapsed py-2" type="button" data-bs-toggle="collapse" data-bs-target="#collapse-<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>" aria-expanded="true" aria-controls="collapse-<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>">
                            <i class="bi me-4 mails_icon" style="margin-bottom: 0.125rem;margin-top: 0.125rem;"></i>
                            <span class="nombre me-auto">--</span>
                            <span style="font-size: x-small;" class="mails_fecha small my-auto px-2 border border-info rounded">12/02</span>
                        </button>
                    </h2>
                    <div id="collapse-<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>" class="accordion-collapse collapse" aria-labelledby="heading-<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>" data-bs-parent="#mailsList_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_rows">
                        <div class="accordion-body row p-1 m-0">
                            <a class="col-2 d-flex p-0 m-0 btn btn-outline-info" href="/" target="_blank">
                                <i class="bi m-auto mails_icon2" style="font-size: xxx-large;"></i>
                            </a>
                            <div class="col p-0 m-0 ms-1 row">
                                <table class="table my-1 table-hover" style="font-size: xx-small;">
                                    <tbody>
                                        <tr>
                                            <td class="p-0 col-3"><i class="bi bi-box-arrow-right mx-3"></i>FROM:</td>
                                            <td class="p-0 mails_form">@fat</td>
                                        </tr>
                                        <tr>
                                            <td class="p-0 col-3"><i class="bi bi-box-arrow-in-right mx-3"></i>TO:</td>
                                            <td class="p-0 mails_to">@fat</td>
                                        </tr>
                                        <tr class="mails_cc">
                                            <td class="p-0 col-3"><i class="bi bi-box-arrow-in-right mx-3"></i>CC:</td>
                                            <td class="p-0 addrs">@fat</td>
                                        </tr>
                                        <tr class="mails_bcc">
                                            <td class="p-0 col-3"><i class="bi bi-box-arrow-in-right mx-3"></i>BCC:</td>
                                            <td class="p-0 addrs">@fat</td>
                                        </tr>
                                        <tr class="mails_replayto">
                                            <td class="p-0 col-3"><i class="bi bi-arrow-90deg-left mx-3"></i></i>replayTo:</td>
                                            <td class="p-0 addrs">@fat</td>
                                        </tr>
                                        <tr>
                                            <td class="p-0 mails_content" colspan="2">Thornton</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="accordion shadow" id="mailsList_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_rows">
                </div>
            </div>
        </div>
    </div>
    <div class="container-fluid py-2" id="active2_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local">
        <div class="container border border-primary rounded p-2 my-1 shadow">
            <h3 class="text-center py-1 border bg-dark text-light rounded"><i class="icon-shell me-4"></i> access to php composer:</h3>
            <ol>
                <li>Open terminal (ej: xterm, tilix, kitty, etc)</li>
                <li>
                    <ul>
                        <li>for <b class="ms-1">PHP7</b>, type this command: <code class="mx-2" style="font-size: larger;">docker exec -it homelab-php7 bash</code> or <code class="mx-2" style="font-size: larger;"><?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?> php7 --user</code></li>
                        <li>for <b class="ms-1">PHP8</b>, type this command: <code class="mx-2" style="font-size: larger;">docker exec -it homelab-php8 bash</code> or <code class="mx-2" style="font-size: larger;"><?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?> php8 --user</code></li>
                    </ul>
                </li>
                <li>exit: <code class="mx-2" style="font-size: larger;">exit</code> or <code class="mx-2" style="font-size: larger;">ctrl+d</code> </li>
            </ol>

        </div>
    </div>
    
    <div class="container-fluid pb-2" id="git_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local">
        <div class="container border border-primary rounded p-2 my-1 shadow">
            <h6 class="d-flex py-2 border bg-dark text-light rounded px-3">
                <i class="bi bi-git me-3"></i> The latest commit on GitHub:
                <a class="ms-auto text-decoration-none" href="/git-info.php" target="_blank">
                    <i class="bi bi-github me-1"></i>
                    <span>GIT Info</span>
                </a>
            </h6>
            <code class="text-center d-block" translate="no" data-bs-toggle="tooltip" data-bs-placement="top" data-bs-original-title="GitHub: <?php echo $objVersion->gitinfo ?? "-"; ?>"><?php echo $objVersion->gitinfo ?? "-"; ?></code>
        </div>
    </div>
<?php
include "./inc/footer.php";
?>
