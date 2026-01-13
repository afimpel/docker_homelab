<?php
$cache = ['error' => null, 'keys' => [], 'uptime' => null, 'server'=> ['version' => null, 'name' => 'Valkey', 'icon' => 'icon-redis', 'icon-alt' => 'icon-redis-alt', 'info' => [], 'dbSize' => null]];

try {
   
    $redis = new Redis();
    $redis->connect($cache_server, $cache_port);
    $cache['server']['version'] = $redis->serverVersion()."-".$redis->serverName();
    $cache['server']['info'] = $redis->info();
    $cache['server']['Keyspace'] = $redis->info('Keyspace');
    $seconds = $redis->info()['uptime_in_seconds'];
    $dtF = new \DateTime('@0');
    $dtT = new \DateTime("@$seconds");
    $interval = $dtF->diff($dtT);
 
    $cache['uptime'] = $interval->format("%Hh %Im");
    $allKeys = $redis->keys('*');
    $cache['dbSize'] = $redis->dbSize();

    if (!empty($allKeys)) {
        $cache['keys'] = $allKeys;
    } 
   
    $redis->close();

} catch (RedisException $e) {
    $cache['error'] = "Error al conectar o interactuar con Redis: " . $e->getMessage();
}
?>