Memcached plugin for Dokku
--------------------------

Project: https://github.com/progrium/dokku

Installation
------------
```
cd /var/lib/dokku/plugins
git clone https://github.com/jezdez/dokku-memcached-plugin memcached
dokku plugins-install
```

Commands
--------
```
$ dokku help
     memcached:create <app>     Create a Memcached container
     memcached:delete <app>     Delete specified Memcached container
     memcached:info <app>       Display container informations
     memcached:link <app> <rd>  Link an app to a Memcached container
     memcached:logs <app>       Display last logs from Memcached contain
```

Simple usage
------------

Create a new Container:
```
$ dokku memcached:create foo            # Server side
$ ssh dokku@server memcached:create foo # Client side

-----> Memcached container created: memcached/foo

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
remote: -----> App foo linked to memcached/foo container
remote:        MEMCACHE_SERVERS=172.16.0.104:11211
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
dokku memcached:delete foo
```

Linking an app to a specific container:
```
dokku memcached:link foo bar
```

Memcached logs (per container):
```
dokku memcached:logs foo
```

Memcached information:
```
dokku memcached:info foo
```

Thanks
------

This is a partially based on the dokku redis plugin: https://github.com/luxifer/dokku-redis-plugin
