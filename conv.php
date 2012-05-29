<?php
if (php_sapi_name() != 'cli')
{
	die("This script works on cli only.");
}

if ($argc != 4)
{
	echo "Usage: \n";
	echo "php conv.php filename outputfile javascriptname\n";
	echo "Filename: File to convert to a javascript Array\n";
	echo "Outputfile: File to save the javascript Array\n";
	echo "Javascriptname: The javascript variable name the data is saved in\n";

	exit;
}

$var = $argv[3];
$open = $argv[1];
$save = $argv[2];

$rs = @fopen ($open, 'r+');

if (!$rs)
{
	die("Coulnt open $open.");
}

$tmp = "window.{$var} = [";

while (!feof ($rs))
{
	$val = fread($rs, 1);
	$tmp .= ord($val);
	$tmp .=  ",";
}
$tmp .= "]";

file_put_contents($save, $tmp);
