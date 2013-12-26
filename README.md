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

This plugin also requires the dokku-link plugin to be installed:
https://github.com/rlaneve/dokku-link


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
