MongoDB plugin for Dokku
---------------------------
Plugin to setup Mongodb accounts for containers deployed to Dokku


Installation
------------
```
git clone https://github.com/jeffutter/dokku-mongodb-plugin.git /var/lib/dokku/plugins/mongodb
dokku plugins-install
```


Commands
--------
```
$ dokku help
     mongodb:create <app>   Create a Mongo database
     mongodb:delete <app>   Delete specified Mongo database
     mongodb:list           List all databases
```

Simple usage
------------
Your need to have app running with the same name!

Create a new DB:
```
$ dokku mongodb:create foo            # Server side
$ ssh dokku@server mongodb:create foo # Client side

    {
        "_id" : ObjectId("524c90dc45addf0edad783a2"),
        "user" : "foo",
        "readOnly" : false,
        "pwd" : "825ec0deacccb3c6bb621d84153e5877"
    }

```

Now if you push your app again, you will have the following ENV variables
```
MONGODB_DATABASE
MONGODB_PORT
MONGODB_USERNAME
MONGODB_PASSWORD
MONGO_URL
```