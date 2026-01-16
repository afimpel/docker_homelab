<?php
    include "./inc/offcanvasExtraInfo.php";
?>
    <script>
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
</body>
</html>