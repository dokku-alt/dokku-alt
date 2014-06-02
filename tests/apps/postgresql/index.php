<?

$url=parse_url(getenv("DATABASE_URL"));

$server = $url["host"];
$username = $url["user"];
$password = $url["pass"];
$db = substr($url["path"],1);

pg_connect("dbname=$db host=$server user=$username password=$password") or die("Failed to connect");

echo "postgresql-buildstep-test"
