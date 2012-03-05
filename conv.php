<?php

$rs = fopen ("linuxstart.bin", 'r+');

echo "window.start = [";

while (!feof ($rs))
{
	$val = fread($rs, 1);
	echo ord($val);
	echo ",";
}
echo "]"

?>
