PostgreSQL plugin for Dokku
------------------------

Project: https://github.com/dokku-alt/dokku-alt

Based on [MariaDB plugin](https://github.com/Kloadut/dokku-md-plugin).


Commands
--------
```
$ dokku help

    postgresql:console <app> <db>                  Launch console for PostgreSQL container
    postgresql:create <db>                         Create a PostgreSQL database
    postgresql:delete <db>                         Delete specified PostgreSQL database
    postgresql:dump <app> <db>                     Dump database for an app
    postgresql:info <app> <db>                     Display application informations
    postgresql:link <app> <db>                     Link database to app
    postgresql:list <app>                          List linked databases
    postgresql:unlink <app> <db>                   Unlink database from app
    postgresql:create_extension <app> <extension>  Create extension in pg database by superuser.
```

Simple usage
------------

Create a new DB:
```
$ dokku postgresql:create mydb            # Server side
$ ssh dokku@server postgresql:create mydb # Client side

CREATE DATABASE
-----> PostgreSQL database created: mydb
```

Deploy your app (client side):
```
$ git remote add dokku git@server:myapp
$ git push dokku master
Counting objects: 155, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (70/70), done.
Writing objects: 100% (155/155), 22.44 KiB | 0 bytes/s, done.
Total 155 (delta 92), reused 131 (delta 80)
remote: -----> Building myapp ...
remote:        Ruby/Rack app detected
remote: -----> Using Ruby version: ruby-2.0.0

... blah blah blah ...
remote: -----> Deploy complete!
remote: -----> Cleaning up ...
remote: -----> Cleanup complete!
remote: =====> Application deployed:
remote:        http://myapp.server
```

Link the database to your application (server side):
```
$ dokku postgresql:link myapp mydb
GRANT
-----> Releasing myapp ...
-----> Deploying myapp ...
-----> Shutting down old containers
=====> Application deployed:
       http://myapp.server

Advanced usage
--------------

Start psql console for a given app and database:
```
dokku postgresql:console myapp mydb
```

You can also pipe SQL script to `postgresql:console`:
```
cat init.sql | dokku postgresql:console myapp mydb
```

Deleting databases:
```
dokku postgresql:delete mydb
```

Linking an app to a specific database:
```
dokku postgresql:link myapp mydb
```

Database information:
```
dokku postgresql:info myapp mydb
```
