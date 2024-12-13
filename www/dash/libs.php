<?php
function errorLogger($data, $hr = false){
    $file = basename($_ENV['SCRIPT_FILENAME'],'.php')."-".PHP_MAJOR_VERSION.".log";
    $filename = date('Y-m-d').'_'.str_replace(".",'-',$_ENV['HTTP_HOST'])."_".$file;
    $hrline = "";
    switch (intval($hr)) {
        case 1:
            $hrline = "--- \t\t".date('r')." --- ".$_SERVER['REQUEST_SCHEME']."://".$_ENV['HTTP_HOST'].$_ENV['REQUEST_URI']." --- ".strtolower($filename)."\t\t --- \n";
            break;
        case 2:
            $hrline = "\n";
            break;
        default:
            $hrline = "";
    }
    $dataVaule = gettype($data) == 'string' ? $data : json_encode($data);
    error_log($hrline."[".date('H:i:s')."]\t ".$dataVaule."\n", 3, '/var/log/sites-logs/'.strtolower($filename));
}

function listSites($files, $directory, $classA, $domain = "", $prefix=""){ 
    $sites=[];
    $sitesLinks = array();
    foreach ($files as $file) {
        if ($file !== '.' && $file !== '..') {
            if (is_dir($directory . $file)) { 
                $type = "nginx-alt";
                if (is_dir($directory . $file.'/node_modules')) { 
                    $type="html";
                }
                if (is_dir($directory . $file.'/public') && is_dir($directory . $file.'/vendor')) { 
                    $type="php";
                }
                $url=$prefix.$file."".$domain;
                $sites[$type][]=["type" => $type, "url" => "$url.local", "directory" => $directory.$file];
                foreach ($classA as $key => $class) {
                    $sitesLinks[$key][]="<a translate='no' title='$url.local' target='_blank' class='$class' href='//$url.local' style='min-width: 15vw;'>\n<i class='icon-$type me-2'></i> $file\n</a>";
                }
            }
        }
    }
    errorLogger(["sitesLinks" => count($files)-3, "directory" => $directory, "sites" => $sites]);
    $output = [];
    foreach ($sitesLinks as $key => $class) {
        $output[$key] = implode("\n",$class);
    }
    return $output;
}