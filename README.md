RabbitMQ plugin for Dokku
=========================

Project: https://github.com/progrium/dokku

Requirements
------------
Docker version `0.7.2` or higher
Dokku version `0.2.1` or higher

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
- fix volumin delete (fix access rights)
- improve creation time
- add peristent logs

Thanks
------
This is partially based on the dokku redis plugin: https://github.com/luxifer/dokku-redis-plugin
