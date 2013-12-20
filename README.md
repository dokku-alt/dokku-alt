Redis plugin for Dokku
----------------------

Project: https://github.com/progrium/dokku

Installation
------------
```
cd /var/lib/dokku/plugins
git clone https://github.com/jezdez/dokku-redis-plugin redis
dokku plugins-install
```

This plugin also requires the dokku-redis-link plugin to be installed:
https://github.com/rlaneve/dokku-link

Commands
--------
```
$ dokku help
     redis:create <app>            Create a Redis container
     redis:delete <app>            Delete specified Redis container
     redis:info <app>              Display container informations
     redis:link <app> <container>  Link an app to a Redis container
     redis:logs <app>              Display last logs from Redis contain
```

Simple usage
------------

Create a new Container:
```
$ dokku redis:create foo            # Server side
$ ssh dokku@server redis:create foo # Client side

-----> Redis container created: redis/foo

       Host: 172.16.0.104
       Private port: 6379
```

Advanced usage
--------------

Deleting containers:
```
dokku redis:delete foo
```

Linking an app to a specific container:
```
dokku redis:link foo bar
```

Redis logs (per container):
```
dokku redis:logs foo
```

Redis information:
```
dokku redis:info foo
```
