<div class="offcanvas offcanvas-end" tabindex="-1" id="offcanvasExtraInfo" aria-labelledby="offcanvasExtraInfoLabel" style="width: 33%;opacity: .95;">
    <div class="offcanvas-header p-2">
        <button type="button" class="btn-close ms-0 me-auto text-reset" data-bs-dismiss="offcanvas" aria-label="Close"></button>
        <h3 class="offcanvas-title" id="offcanvasExtraInfoLabel">Extra information.</h3>
    </div>
    <div class="offcanvas-body p-2">
        <div class="list-group shadow">
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
        <?php
        $directory = './*.php'; // Matches all files ending with .php in the current directory
        $php_files = glob($directory);
        if (count($php_files)>4){ ?>
        <h4 class="mt-3 mb-0 py-1">Extra Files.</h4>
        <div class="mt-1 list-group shadow fs-6">
        <?php
        $not_files = ['./phpinfo.php', './uptime.php', './manual.php', './index.php'];
        foreach ($php_files as $file ) {
        	if (!in_array($file, $not_files)) {?>
                <a translate="no" data-bs-toggle="tooltip" data-bs-placement="left" data-bs-original-title="<?=mime_content_type($file); ?>" class="list-group-item list-group-item-info list-group-item-action p-1 px-2" href="<?=$file; ?>" target="_blank" style="font-size: 0.6rem !important;"><i class=" icon-php mx-2"></i><?=$file; ?></a>
        	<?php }
        }
        ?>
        </div>
        <?php } ?>
        <h4 class="mt-4">Networks.</h4>
        <div class="mt-3 list-group shadow">
            <a data-bs-toggle="tooltip" data-bs-placement="left" data-bs-original-title="The GitHub repository for the current project." class="list-group-item list-group-item-secondary list-group-item-action p-1 px-2" target="_blank" rel="noopener" href="https://github.com/afimpel/docker_homelab"><i class="bi bi-github mx-2"></i> GitHub</a>
            <a data-bs-toggle="tooltip" data-bs-placement="left" data-bs-original-title="My main website." class="list-group-item list-group-item-info list-group-item-action p-1 px-2" target="_blank" rel="noopener" href="https://www.afimpel.com/"><i class="bi bi-browser-firefox mx-2"></i> afimpel</a>
        </div>
    </div>
    <div class="input-group input-group-sm mb-1 px-2">
        <span class="input-group-text bg-dark text-light" id="inputGroup-sizing-sm">Select Theme:</span>
        <select id="select_bootswatch" class="form-select"></select>
    </div>

    <div class="p-2 mb-4">
        <p class="d-flex">Theme used in the dashboard:<a id="select_bootswatch_www" class="ms-auto text-decoration-none" href="//bootswatch.com/spacelab/" target="_blank"><i class="bi bi-bootstrap-fill mx-2"></i><span id="select_bootswatch_text"></span></a></p>
        <h6 class="text-center py-1 border bg-dark text-light rounded"><i class="icon-git me-4"></i> the latest commit on GitHub:</h6>
        <code class="text-center d-block" translate="no" data-bs-toggle="tooltip" data-bs-placement="left" data-bs-original-title="GitHub: <?php echo $objVersion->gitinfo ?? "-"; ?>"><?php echo $objVersion->gitinfo ?? "-"; ?></code>
    </div>
</div>
