<?php
$mailer = ['error' => null, "link" => null, "unread" => 0, "counter" => 0, "rows" => 0, 'uptime' => null, 'server'=> ['version' => null, 'name' => 'Mailpit', 'icon' => 'bi bi-envelope-paper-fill', 'icon-alt' => 'bi bi-envelope-paper', 'info' => [], 'dbSize' => null]];

try {
    $obj = getData('info');
    $messagesOBJ = getData('messages');
    $mailer['link'] = "//mailer.".strtolower(getenv('COMPOSE_PROJECT_NAME')).".local/";
    $mailer['unread'] = $obj->Unread;
    $mailer['counter'] = $obj->Messages;
    $mailer['rows'] = $messagesOBJ->messages;
    $mailer['uptime'] = segToHuman($obj->RuntimeStats->Uptime);
    $mailer['server']['version'] = $obj->Version;
    $mailer['server']['info'] = $obj->RuntimeStats;
    $mailer['server']['Memory'] = $obj->RuntimeStats->Memory;
    $mailer['server']['dbSize'] = $obj->DatabaseSize;

} catch (Exception $e) {
    $mailer['error'] = "Mailer: " . $e->getMessage();
}

function segToHuman($seg){
    $h = floor($seg / 3600);
    $m = floor(($seg % 3600) / 60);
    return sprintf('%02dh %02dm', $h, $m);
}

function getData($curlUrl){
    $curl = curl_init();

    curl_setopt_array($curl, array(
    CURLOPT_URL => 'http://homelab-mailer:8025/api/v1/'.$curlUrl,
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_ENCODING => '',
    CURLOPT_MAXREDIRS => 10,
    CURLOPT_TIMEOUT => 0,
    CURLOPT_FOLLOWLOCATION => true,
    CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
    CURLOPT_CUSTOMREQUEST => 'GET',
    ));

    $response = curl_exec($curl);
    return json_decode($response);

}

?>