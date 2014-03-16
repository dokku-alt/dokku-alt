## Dokku plugin to rebuild an app without a git push

Commands
--------
```
$ dokku help
     rebuild <app>     Rebuilds specified app
     rebuild:all       Rebuilds all apps
```

Installation
------------
```
cd /var/lib/dokku/plugins
git clone https://github.com/scottatron/dokku-rebuild dokku-rebuild
dokku plugins-install
```
