<?php
$dbs = ['error' => null, 'database' => [], 'uptime' => null, 'server'=> ['version' => null, 'name' => getenv('DATABASE_IMAGES'), 'icon' => 'icon-'.strtolower(getenv('DATABASE_IMAGES')), 'icon-alt' => 'icon-mysql-alt' ] ];
try {
    $mysqli = new mysqli("homelab-database", getenv('DATABASE_USER'), getenv('DATABASE_PASSWORD'), NULL, getenv('DATABASE_PORT'));

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
    } else {
        $dbs['error'] = $mysqli->error;
    }

} catch (Exception $e) {
    $dbs['error'] = $e->getMessage();
} finally {
    if (isset($mysqli)) {
        $mysqli->close();
    }
}
