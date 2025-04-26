<?php
namespace docker {
	function adminer_object() {
		/**
		 * DefaultServerPlugin extends loginFormField() to set default values for the login form.
		 * @author Alvaro Fimpel <afimpel@afimpel.com>
		 * @link https://github.com/afimpel/docker_homelab
		 * @license MIT
		 */
		final class DefaultServerPlugin extends \Adminer\Plugin {
			public function __construct(
				private \Adminer\Adminer $adminer
			) { }

			public function loginFormField(...$args) {
				return (function (...$args) {
					$field = $this->loginFormField(...$args);

					$server = $_GET['server'] ?? ($_ENV['ADMINER_DEFAULT_SERVER'] ?? 'homelab-database');
					$username = $_GET['username'] ?? ($_ENV['ADMINER_DEFAULT_USERNAME'] ?? 'root');
					$password = $_GET['password'] ?? ($_ENV['ADMINER_DEFAULT_PASSWORD'] ?? '');
					$database = $_GET['db'] ?? ( $_ENV['ADMINER_DEFAULT_DB'] ?? '');
					
					$field = \str_replace(
						'name="auth[username]" id="username"',
						\sprintf('name="auth[username]" value="%s" title="username"', $username),
						$field,
					);
					$field = \str_replace(
						'name="auth[password]"',
						\sprintf('name="auth[password]" value="%s" title="password"', $password),
						$field,
					);
					$field = \str_replace(
						'name="auth[db]"',
						\sprintf('name="auth[db]" value="%s" title="db"', $database),
						$field,
					);

					return \str_replace(
						'name="auth[server]" value="" title="hostname[:port]"',
						\sprintf('name="auth[server]" value="%s" title="hostname[:port]"', $server),
						$field,
					);
				})->call($this->adminer, ...$args);
			}
		}

		$plugins = [];
		foreach (glob('plugins-enabled/*.php') as $plugin) {
			$plugins[] = require($plugin);
		}

		$adminer = new \Adminer\Plugins($plugins);

		(function () {
			$last = &$this->hooks['loginFormField'][\array_key_last($this->hooks['loginFormField'])];
			
			if ($last instanceof \Adminer\Adminer) {
				$defaultServerPlugin = new DefaultServerPlugin($last);
				$this->plugins[] = $defaultServerPlugin;
				$last = $defaultServerPlugin;
			}
		})->call($adminer);


		return $adminer;
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
