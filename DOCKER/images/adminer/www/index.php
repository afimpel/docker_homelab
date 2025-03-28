<?php

namespace docker {
	function adminer_object() {
		require_once('plugins/plugin.php');

		class Adminer extends \AdminerPlugin {
			function _callParent($function, $args) {
				if ($function === 'loginForm') {
					ob_start();
					$return = \Adminer::loginForm();
					$form = ob_get_clean();
					
					$form = str_replace('name="auth[server]" value="" title="hostname[:port]"', 'name="auth[server]" value="'.($_ENV['ADMINER_DEFAULT_SERVER'] ?: 'homelab-database').'" title="hostname[:port]"', $form);
					$form = str_replace('name="auth[username]" id="username" value=""', 'name="auth[username]" id="username" value="'.($_ENV['ADMINER_DEFAULT_USERNAME'] ?: 'root').'" ', $form);
					echo str_replace('name="auth[password]"', 'name="auth[password]" value="'.($_ENV['ADMINER_DEFAULT_PASSWORD'] ?: '').'"', $form);
					echo '<br /><br /><br /><hr /><a class="links" href="/phpinfo.php">PHP '.phpversion().'</a><hr />';
					return $return;
				}
				return parent::_callParent($function, $args);
			}
		}

		$plugins = [];
		foreach (glob('plugins-enabled/*.php') as $plugin) {
			$plugins[] = require($plugin);
		}

		return new Adminer($plugins);
	}
}

namespace {
	ini_set('display_errors', 0);
	if ($_SERVER['REQUEST_URI'] === '/adminer.css' && is_readable('adminer.css')) {
		header("Expires: on, 01 Jan 1970 00:00:00 GMT");
		header("Last-Modified: " . gmdate("D, d M Y H:i:s") . " GMT");
		header("Cache-Control: no-store, no-cache, must-revalidate");
		header("Cache-Control: post-check=0, pre-check=0", false);
		header("Pragma: no-cache");
		header('Content-Type: text/css');
		readfile('adminer.css');
		exit;
	}

	function adminer_object() {
		return \docker\adminer_object();
	}

	require('adminer.php');
}
