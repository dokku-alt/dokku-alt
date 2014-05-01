Redis plugin for Dokku
----------------------

Project: https://github.com/progrium/dokku

Installation
------------
```
cd /var/lib/dokku/plugins
git clone https://github.com/luxifer/dokku-redis-plugin redis
dokku plugins-install
```


Commands
--------
```
$ dokku help
     redis:create <app>     Create a Redis container
     redis:delete <app>     Delete specified Redis container
     redis:info <app>       Display container informations
     redis:link <app> <rd>  Link an app to a Redis container
     redis:logs <app>       Display last logs from Redis contain
```

Simple usage
------------

Create a new Container:
```
$ dokku redis:create foo            # Server side
$ ssh dokku@server redis:create foo # Client side

-----> Redis container created: redis/foo

       Host: 172.16.0.104
       Public port: 49187
```

Deploy your app with the same name (client side):
```
$ git remote add dokku git@server:foo
$ git push dokku master
Counting objects: 155, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (70/70), done.
Writing objects: 100% (155/155), 22.44 KiB | 0 bytes/s, done.
Total 155 (delta 92), reused 131 (delta 80)
remote: -----> Building foo ...
remote:        Ruby/Rack app detected
remote: -----> Using Ruby version: ruby-2.0.0

... blah blah blah ...

remote: -----> Deploying foo ...
remote: 
remote: -----> App foo linked to redis/foo container
remote:        REDIS_IP=172.16.0.104
remote: 
remote: -----> Deploy complete!
remote: -----> Cleaning up ...
remote: -----> Cleanup complete!
remote: =====> Application deployed:
remote:        http://foo.server
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
