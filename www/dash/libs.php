<?php
function errorLogger($data, $hr = false, $title = ""){
    $file = basename($_ENV['SCRIPT_FILENAME'],'.php')."-".PHP_MAJOR_VERSION.".log";
    $filename = date('Y-m-d').'_'.str_replace(".",'-',$_ENV['HTTP_HOST'])."_".$file;
    $hrline = "";
    switch (intval($hr)) {
        case 1:
            $hrline = "--- \t\t".date('r')." --- ".$_SERVER['REQUEST_SCHEME']."://".$_ENV['HTTP_HOST'].$_ENV['REQUEST_URI']." --- ".strtolower($filename)."\t\t --- \n";
            break;
        case 2:
            $hrline = "--- \t\t$title\t\t ---\n";
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
                if (is_dir($directory . $file.'/build')) { 
                    $type="html";
                }
                if (is_dir($directory . $file.'/public')) { 
                    $type="php-alt";
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
    //errorLogger(["sitesLinks" => count($files)-3, "directory" => $directory, "sites" => $sites]);
    $output = [];
    foreach ($sitesLinks as $key => $class) {
        $output[$key] = implode("\n",$class);
    }
    return $output;
}

function listSitesJSON($typeJSON, $classA, $function, $strReplace){ 
    $sites=[];
    $sitesLinks = array();
    $listSitesOBJ = json_decode(file_get_contents($typeJSON.'.json'));
    $output = ["","",count($listSitesOBJ->items)];
    usort($listSitesOBJ->items, function($a, $b) {
        return strcmp($a->title, $b->title);
    });
    foreach ($listSitesOBJ->items as $site) {
        foreach ($classA as $key => $class) {
            $typeStr=strtoupper($site->type);
            $type = "nginx-alt text-success";
            if (str_contains($site->type, 'build')){
                $type="html text-warning";
            }elseif (str_contains($site->type, 'legacy-php')){
                $type="php text-primary";
            }elseif (str_contains($site->type, 'php')){
                $type="php-alt text-info";
            }
            $site_ID=str_ireplace('://','_',str_ireplace('.','_',$site->url));
            $onloadFunction=str_replace($strReplace[$key][1],$site->url,$function[$key][0]);
            $onloadFunction=str_replace($strReplace[$key][0],$site_ID,$onloadFunction);
            $onloadReplace=str_replace($strReplace[$key][0],$site_ID,$function[$key][1]);
            $attrExtras=str_replace($strReplace[$key][0],$site_ID,$function[$key][2]);
            $attrExtras=str_replace($strReplace[$key][4],parse_url($site->url, PHP_URL_HOST),$attrExtras);
            $attrExtras=str_replace($strReplace[$key][1],$site->url,$attrExtras);
            $attrExtras=str_replace($strReplace[$key][2],$typeStr,$attrExtras);
            $attrExtras=str_replace($strReplace[$key][3],$site->title,$attrExtras);

            #errorLogger([$strReplace[$key], $site_ID, $function[$key], [$onloadFunction, $onloadReplace, $attrExtras]]);
            $sitesLinks[$key][]="<a translate='no' $attrExtras target='_blank' class='$class' href='$site->url' style='min-width: 15vw;'><i class='icon-$type me-2'></i>$onloadFunction $site->title ➤ $typeStr $onloadReplace</a>";
        }
    }

    foreach ($sitesLinks as $key => $class) {
        $output[$key] = implode("\n",$class);
    }
    return $output;
}