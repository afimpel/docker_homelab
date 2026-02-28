<?php
include "./inc/config.php";
include "./inc/libs.php";
include "./inc/dbs.php";
include "./inc/cache.php";
include "./inc/mailer.php";
$funtionsITEMS=[
    ['','',"name='ITEMNODESITEID_tooltip' data-bs-toggle='tooltip' data-bs-placement='right' data-bs-original-title='🌐 ITEMNODESITETITLE ➤ ITEMNODESITETYPE ➤ ITEMNODESITEURLSHORT' data-title='ITEMNODESITETITLE ➤ ITEMNODESITETYPE'"],
    ['<script>listSitesURL(\'ITEMNODESITEID\',\'ITEMNODESITEURL\');</script>','<small style=\'font-size: xx-small;\' class=\'badge text-light bg-primary rounded ms-auto my-auto\' name=\'ITEMNODESITEID\'>-</small>',"name='ITEMNODESITEID_tooltip' data-bs-toggle='tooltip' data-bs-placement='left' data-bs-original-title='🌐 ITEMNODESITETITLE ➤ ITEMNODESITETYPE ➤ ITEMNODESITEURLSHORT' data-title='ITEMNODESITETITLE ➤ ITEMNODESITETYPE'"],
    ['<script>listSitesURL(\'ITEMNODESITEID\',\'ITEMNODESITEURL\');</script>','<small style=\'font-size: xx-small;\' class=\'badge text-light bg-primary rounded ms-auto my-auto\' name=\'ITEMNODESITEID\'>-</small>',"name='ITEMNODESITEID_tooltip' data-bs-toggle='tooltip' data-bs-placement='left' data-bs-original-title='🌐 ITEMNODESITETITLE ➤ ITEMNODESITETYPE ➤ ITEMNODESITEURLSHORT' data-title='ITEMNODESITETITLE ➤ ITEMNODESITETYPE'"]
];
$replaceITEMS=[
    ['ITEMNODESITEID','ITEMNODESITEURL','ITEMNODESITETYPE','ITEMNODESITETITLE','ITEMNODESITEURLSHORT'],
    ['ITEMNODESITEID','ITEMNODESITEURL','ITEMNODESITETYPE','ITEMNODESITETITLE','ITEMNODESITEURLSHORT'],
    ['ITEMNODESITEID','ITEMNODESITEURL','ITEMNODESITETYPE','ITEMNODESITETITLE','ITEMNODESITEURLSHORT']
];
$classITEMS=[
    "dropdown-item",
    "list-group-item list-group-item-action list-group-item-secondary py-1 d-flex", 
    "list-group-item list-group-item-action list-group-item-secondary py-1 d-flex"
];
$typeITEMS=[
    "navbar",
    "gral",
    'group'
];
$sitesDomain = listSitesJSON("domains", $typeITEMS, $classITEMS, $funtionsITEMS, $replaceITEMS);
$sitesSubdomain = listSitesJSON("subdomains", $typeITEMS, $classITEMS, $funtionsITEMS, $replaceITEMS);
$objVersion = json_decode(file_get_contents('version.json'));
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <link rel="icon" href="./favicon.ico" />
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><?php echo isset($titleNavs) ? $titleNavs." ➤ " : ""; ?>LEMP STACK ➤ <?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local </title>
    <link id="theme_bootswatch" rel="stylesheet" href="https://bootswatch.com/5/spacelab/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-mfizz/2.4.1/font-mfizz.min.css" integrity="sha512-Cdvnk1SFWqcb3An6gMyqDRH40Js8qmsWcSK10I2gSifCe2LilaPMsHd6DldEvQ3uIlCb1qdRUrNeAFFleOu4xQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.min.css" integrity="sha256-pdY4ejLKO67E0CM2tbPtq1DJ3VGDVVdqAR6j3ZwdiE4=" crossorigin="anonymous">
    <style>
        small::before{ margin-right: .5rem;}
        .btn::before{ margin-right: .5rem;}
        .tooltip-inner { max-width: 90vw; font-family: monospace; padding-right: 1rem; padding-left: 1rem; }
        .accordion-button::after { margin-left: 1rem; }
        .bg-body-tertiary { --bs-bg-opacity: 0.85 !important; backdrop-filter: blur(2px); -webkit-backdrop-filter: blur(2px); }
    </style>
    <script src="https://<?php echo strtolower(getenv('COMPOSE_PROJECT_NAME')); ?>.local/files.js" crossorigin="anonymous"></script>
</head>

<body style="padding-top: 96px;">
