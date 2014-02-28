PostgreSQL plugin for Dokku
---------------------------

Project: https://github.com/progrium/dokku

**Warning: This plugin is under development and still only tested with the below dependencies**

Requirements
------------
* Docker version `0.7.2` or higher
* Dokku version `0.2.1` or higher

Installation
------------
```
cd /var/lib/dokku/plugins
git clone https://github.com/Kloadut/dokku-pg-plugin postgresql
dokku plugins-install
```


Commands
--------
```
$ dokku help
    postgresql:create <db>                         Create a PostgreSQL container
    postgresql:delete <db>                         Delete specified PostgreSQL container
    postgresql:dump <db> > dump_file.sql           Dump database data
    postgresql:info <db>                           Display database informations
    postgresql:link <app> <db>                      Link an app to a PostgreSQL database
    postgresql:list                                 Display list of PostgreSQL containers
    postgresql:logs <db>                           Display last logs from PostgreSQL container
    postgresql:restore <db> < dump_file.sql        Restore database data from a previous dump
```

Simple usage
------------

Create a new DB:
```
$ dokku postgresql:create foo            # Server side
$ ssh dokku@server postgresql:create foo # Client side

-----> PostgreSQL container created: postgresql/foo

       Host: 172.17.42.1
       User: 'root'
       Password: 'RDSBYlUrOYMtndKb'
       Database: 'db'
       Public port: 49187
```

Deploy your app with the same name (client side):
```
$ git remote add dokku git@server:foo
$ git push dokku master

```

Link your app to the database
```bash
dokku postgresql:link app_name database_name
```


Advanced usage
--------------

Inititalize the database with SQL statements:
```
cat init.sql | dokku postgresql:create foo
```

Deleting databases:
```
dokku postgresql:delete foo
```

Linking an app to a specific database:
```
dokku postgresql:link foo bar
```

PostgreSQL logs (per database):
```
dokku postgresql:logs foo
```

Database informations:
```
dokku postgresql:info foo
```

List of containers:
```
dokku postgresql:list
```

Dump a database:
```
dokku postgresql:dump foo > foo.sql
```

Restore a database:
```
dokku postgresql:restore foo < foo.sql
```
