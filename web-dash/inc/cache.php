<?php
$cache = ['error' => null, 'keys' => [], "counter" => 0, 'database' => [], 'uptime' => null, 'server'=> ['version' => null, 'name' => 'Valkey', 'icon' => 'icon-redis', 'icon-alt' => 'icon-redis-alt', 'info' => [], 'dbSize' => null]];

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
    $allKeys = [];
    $cache['dbSize']=0;
    $info = $redis->info('Keyspace');
    foreach ($info as $key => $value) {
        $code = intval(substr($key,-1));
        $redis->select($code);
        $keys[$key] = $redis->keys('*');
        $cache['counter']=$cache['counter']+count($keys[$key]);
        $allKeys = array_merge($allKeys, $keys);
        $cache['database'][$key]['value'] = $value;
        $cache['database'][$key]['dbSize'] = $redis->dbSize();
        $cache['dbSize']=$cache['dbSize']+$redis->dbSize();
        $cache['database'][$key]['code'] = $key;
        $cache['database'][$key]['keys'] = $keys;
    }
    if (!empty($allKeys)) {
        $cache['keys'] = $allKeys;
    } 
   
    $redis->close();

} catch (RedisException $e) {
    $cache['error'] = "Error al conectar o interactuar con Redis: " . $e->getMessage();
}
?>