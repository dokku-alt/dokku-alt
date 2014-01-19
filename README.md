Rabbitmq plugin for Dokku
=========================

Project: https://github.com/progrium/dokku

Instalation
-----------
```
cd /var/lib/dokku/plugins
git clone https://github.com/jlachowski/dokku-rabbitmq-plugin.git rabbitmq
dokku plugins-install
```

Commands
--------
```
$ dokku help
    rabbitmq:create <app>           Create a Rabbitmq container
    rabbitmq:delete <app>           Delete specific Rabbitmq container
    rabbitmq:info <app>             Display container informations
    rabbitmq:link <app> <rabbit>    Link an app to a Rabbitmq container
    rabbitmq:logs <app>             Display last logs from Rabbitmq container
```

TODO:
-----
- improve creation time
- add peristent logs

Thanks
------
This is based on the dokku redis plugin: https://github.com/luxifer/dokku-redis-plugin
