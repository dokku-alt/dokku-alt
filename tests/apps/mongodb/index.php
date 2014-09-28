<?

$mongo_url = getenv("MONGODB_URL") ?: getenv("MONGOHQ_URL");
$mongo_url2 = parse_url($mongo_url);
$dbname = str_replace("/", "", $mongo_url2["path"]);
$db = new MongoClient($mongo_url) or die("Couldn't connect to mongo");
$db  = $db->$dbname or die("Couldn't select database");

echo "mongodb-buildstep-test";
