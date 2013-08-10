PostgreSQL plugin for Dokku
---------------------------

Project: https://github.com/progrium/dokku


Installation
------------
```
cd /var/lib/dokku/plugins
git clone https://github.com/Kloadut/dokku-pg-plugin
dokku plugins-install
```


Usage
-----
```
$ dokku help
    pg:create <app>       Create a postgresql container
    pg:delete <app>       Stop the specified postgresql container and remove associated image
    pg:port <app>         Display postgresql public port
    pg:logs <app>         Display last logs from postgresql container
```
