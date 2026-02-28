<div class="container-fluid border-top border-bottom my-4 bg-body-tertiary shadow">
    <div class="container">
        <footer class="d-flex flex-wrap justify-content-between align-items-center py-0 my-2">
            <div class="col-md-4 d-flex align-items-center">
                <a data-bs-toggle="tooltip" data-bs-placement="top" data-bs-original-title="LEMP STACK ➤ Compose: <?php echo strtoupper(getenv('COMPOSE_PROJECT_NAME')); ?> ➤ Your local development environment in Docker" href="//www.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local" href="/" class="mb-3 me-2 mb-md-0 px-1 py-0 text-decoration-none lh-1" aria-label="Bootstrap">
                    <i class="icon-docker"></i> LEMP STACK -- <?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local
                </a>
            </div>
            <ul class="nav col-md-8 justify-content-end list-unstyled d-flex">
                <li class="nav-item px-1">
                    <a name="php7_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local_tooltip" data-bs-toggle="tooltip" data-bs-placement="top" class="nav-link px-1 py-0" target="_blank" href="//php7.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/"><i class="me-2 text-info icon-php"></i> PHP7</a>
                </li>
                <li class="nav-item px-1">
                    <a name="php8_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local_tooltip" data-bs-toggle="tooltip" data-bs-placement="top" class="nav-link px-1 py-0" target="_blank" href="//php8.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/"><i class="me-2 text-info icon-php"></i> PHP8</a>
                </li>
                <li class="nav-item px-1">
                    <a data-bs-toggle="tooltip" data-bs-placement="top" data-bs-original-title="🌐 adminer.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local ➤ Adminer" class="nav-link px-1 py-0" target="_blank" href="//adminer.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/"><i class="me-2 icon-database"></i> Adminer</a>
                </li>
                <li class="nav-item px-1">
                     <a translate="no" data-bs-toggle="tooltip" data-bs-placement="top" data-bs-original-title="Manual Homelab" class="nav-link px-1 py-0" href="/manual.php" target="_blank"><i class=" icon-php mx-2"></i> Manual</a>
                </li>
            </ul>
        </footer>
    </div>
</div>

<?php
    include "./inc/offcanvasExtraInfo.php";
?>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5/dist/js/bootstrap.bundle.min.js" integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI" crossorigin="anonymous"></script>
    <script>
        function recursiveLoop(kkk) {
            dataUptimeUrl('/uptime.php', '<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>');
            setTimeout(recursiveLoop, <?php echo getenv('TIMEUOT_DASHBOARD'); ?>);
        }
        recursiveLoop();
        toggleThemeMenu();
        dataUrl("https://adminer.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/","adminer_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local");
        dataUrl("https://mailer.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/","mailer_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local");
        dataUrl("https://redis.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/","redis_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local");
        dataUrl("https://php8.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/","php8_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local");
        dataUrl("https://php7.<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/","php7_<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>_local");
        const tooltipElements = document.querySelectorAll('[data-bs-toggle="tooltip"], .toggle_tooltip');
        
        for (const tooltip of tooltipElements) {
            new bootstrap.Tooltip(tooltip); // eslint-disable-line no-new
        }  
    </script>
    <script src="https://<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/files_footer.js" crossorigin="anonymous"></script>
</body>
</html>