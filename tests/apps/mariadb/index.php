<?

$url=parse_url(getenv("DATABASE_URL"));

$server = $url["host"];
$username = $url["user"];
$password = $url["pass"];
$db = substr($url["path"],1);

mysql_connect($server, $username, $password) or die("Failed to connect");
mysql_select_db($db) or die("Failed to select database");

echo "mariadb-buildstep-test"
