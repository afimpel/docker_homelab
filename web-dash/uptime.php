<?php
include "./inc/config.php";
include "./inc/dbs.php";
include "./inc/cache.php";

$dateTime = new DateTime('now');
$dataArray = array();
$dataArray['database']=$dbs;
$dataArray['cache']=$cache;
$dateTime->setTimezone(new DateTimeZone($_ENV['TZ']));
$dataArray['datetime']=$dateTime->format('r');


http_response_code(200);
header('Content-Type: application/json');
echo json_encode(['STATUS' => 200, "MESSAGE" => "Done", "data" => $dataArray, 'ERROR' => NULL, "datetime" => date('c')]);