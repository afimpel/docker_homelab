<?php 
header("Access-Control-Allow-Origin: *");
function human_filesize($bytes, $decimals = 2) {
    $factor = floor((strlen($bytes) - 1) / 3);
    if ($factor > 0) $sz = 'KMGT';
    return sprintf("%.{$decimals}f", $bytes / pow(1024, $factor)) ." ". @$sz[$factor - 1] . 'B';
}
ob_start();
phpinfo(); 
$out2 = ob_get_contents();
ob_end_clean();
$out2 = str_replace(".e {", ".e { text-align: right; vertical-align: middle; ", $out2);
$out2 = str_replace(".v {", ".v { white-space: pre-line; ", $out2);
$out2 = str_replace("150%", "220%", $out2);
$out2 = str_replace("125%", "150%", $out2);
$out2 = str_replace("934px", "98%", $out2);
$out2 = str_replace("300px", "350px", $out2);
$out2 = str_replace("></tr>", ">\n\t</tr>", $out2);
$out2 = str_replace("<tr", "\t<tr", $out2);
$out2 = str_replace("i\n </td>", "i\n\t\t</td>", $out2);
$out2 = str_replace("><td", ">\n\t\t<td", $out2);
$out2 = str_replace("\n</p>\n</td>", "</p></td>", $out2);
$out2 = str_replace("><th", ">\n\t\t<th", $out2);

$out2 = str_replace("</div></body></html>", "\n</div><br />\n\t</body>\n</html>", $out2);
$out1 = explode("<hr />", $out2);
$out3 = explode("<body>", $out1[0]);

echo $out3[0]."\n \n";
echo "<body>\n";
echo "<h1>Welcome to new typeSite: ".$_SERVER['HTTP_HOST']." ( ⛁ COMPOSE_PROJECT_NAME )</h1> <hr />";
echo $out3[1]."\n \n";
echo "<h1> Site information </h1>\n\n<h2> Connection details </h2>\n\n \n<table>\n\t";
echo "<tr>\n\t\t<td class='e'>SERVER NAME</td>\n\t\t<td class='v'>".php_uname('n')." / ".($_SERVER['HTTP_X_FORWARDED_FOR'] ?? "-")." / ".$_SERVER['HTTP_HOST']." ( ⛁ homelab )"."</td>\n\t</tr>\n";
echo "<tr>\n\t\t<td class='e'>REMOTE NAME</td>\n\t\t<td class='v'>".gethostbyaddr($_SERVER['REMOTE_ADDR'])." / ".$_SERVER['REMOTE_ADDR']."</td>\n\t</tr>\n";
echo "</table>\n";
echo "<h2> List of files </h2>\n<table>\n\t<tr class='h'>\n\t\t<th>File</th>\n\t\t<th>Size</th>\n\t\t<th>Type</th>\n\t</tr>";
foreach (scandir("./") as $ext ) {
	if ($ext != "." && $ext != ".."){
		echo "\n\t<tr>\n\t\t<td class='e'><a href='$ext' target='_blank'>".$ext."</a></td>";
		echo "\n\t\t<td class='v'>";
		echo human_filesize(filesize($ext));
		echo "</td>";
		echo "\n\t\t<td class='v'>";
		echo mime_content_type($ext);
		echo "</td>\n\t</tr>";
	}
}
echo "\n</table><hr />\n";
echo $out1[1]."\n \n";

echo "<h2> Extensions </h2>\n\n<table>\n\t<tr class='h'>\n\t\t<th>Variable</th>\n\t\t<th>Version</th>\n\t</tr>";

foreach (get_loaded_extensions() as $ext ) {
	echo "\n\t<tr>\n\t\t<td class='e'>".$ext."</td>\n\t\t<td class='v'>";
	echo phpversion($ext);
	echo "</td>\n\t</tr>";
}
echo "\n</table><hr />\n";

echo "<h2> Classes </h2>\n<table>\n\t<tr class='h'>\n\t\t<th>Variable</th>\n\t\t<th>Value</th>\n\t</tr>";

foreach (get_declared_classes() as $c ) {
	echo "\n\t<tr>\n\t\t<td class='e'>".$c."</td>\n\t\t<td class='v'>";
	echo implode(", ", get_class_methods($c));
	echo "</td>\n\t</tr>";
}
echo "\n</table>\n \n <b>wwwSite.local</b>\n";

$__out__ = explode('<h2>PHP License</h2>',$out1[2]);
echo $__out__[0];
echo "<h2>PHP License</h2>\n";
$__outs__ = str_replace("\n<p>", '', $__out__[1]);
$__outs__ = str_replace("<td>\n", '<td>', $__outs__);
$__outs__ = str_replace("</p>", '', $__outs__);
echo $__outs__;
?>
