<?php
namespace Adminer\Plugins;

use Adminer\Plugin;
/**
 * Plugin for Adminer to add a link to the PHP info page and a link to the HomeLAB website.
 * @author Alvaro Fimpel <afimpel@afimpel.com>
 * @link https://github.com/afimpel/docker_homelab
 * @version 1.0.0
 * @package Adminer
 * @subpackage Plugins
 * @license MIT
 */

class HomeLAB extends Plugin
{
    function navigation($args)
    {
        echo "<p style='position: fixed; bottom: 0.5em; left: 19%; border: none;padding: 1px;font-size: 10px;right: 3%;text-align: right;'>
            <a href='/phpinfo.php' target='_blank' style='margin-right: 1em;' title='PHP Info'>PHP ".phpversion()."</a>";
            if (getenv('COMPOSE_PROJECT_NAME')){
                echo "<a href='//www.".strtolower(getenv('COMPOSE_PROJECT_NAME')).".local' target='_blank' title='HomeLAB: ".getenv('COMPOSE_PROJECT_NAME')."'>back to HomeLAB</a>";
            }
        echo "</p>";
    }
}

return new HomeLAB;
