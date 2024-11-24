<?php
$dbs = ['error' => null, 'database' => [], 'uptime' => 0, 'server'=> ['version' => null, 'name' => 'mariaDB', 'icon' => 'icon-mariadb', 'icon-alt' => 'icon-mysql-alt' ] ];
try {
    $mysqli = new mysqli("homelab-mariadb", getenv('DB_USER'), getenv('DB_PASSWORD'), NULL, getenv('DB_PORT'));

    if ($mysqli->connect_error) {
        $dbs['error'] = $mysqli->connect_error;
        throw new Exception("Error de conexión: " . $mysqli->connect_error);
    }

    $dbs['server']['version'] = $mysqli->server_info;
    $query = "SHOW DATABASES WHERE Database NOT LIKE 'information_schema';";
    $result = $mysqli->query($query);

    if ($result) {
        $dbs['database'] = $result->fetch_all(MYSQLI_BOTH);
        $result->close();
    } else {
        $dbs['error'] = $mysqli->error;
    }


    $query2 = "select TIME_FORMAT(SEC_TO_TIME(VARIABLE_VALUE ),'%Hh %im') as uptime from information_schema.GLOBAL_STATUS where VARIABLE_NAME='Uptime';";
    $result2 = $mysqli->query($query2);

    if ($result2) {
        $dbs['uptime'] = $result2->fetch_array()[0];
        $result2->close();
    }

} catch (Exception $e) {
    $dbs['error'] = $e->getMessage();
} finally {
    if (isset($mysqli)) {
        $mysqli->close();
    }
}
