# Dokku Alternative

Docker powered mini-Heroku. The smallest PaaS implementation you've ever seen. It's fork of original [dokku](https://github.com/progrium/dokku). The idea behind this fork is to provide complete solution with plugins covering most of use-cases which are stable and well tested.

## Features

* Debian-based installation and upgrade!
* Git deploy
* Built-in support for MariaDB, PostgreSQL, MongoDB and Redis databases
* Built-in support for Dockerfile
* Built-in support for service-only applications
* Built-in support for domains and redirects
* Built-in support for TLS and wildcard certificates
* Built-in support for Docker-args and container persistent volumes
* Built-in support for container's TOP
* Built-in support for foreman-based Procfile
* Preboot / zero-downtime deploy (in beta)
* Data volumes (in beta)

### Planned features:

* Full, partial and incremental backup
* Access-control: deploy only keys, non-admin users
* Application migration
* Data volumes

## Requirements

Assumes that you use Ubuntu 14.04 LTS right now. Ideally have a domain ready to point to your host. It's designed for and is probably best to use a fresh VM. The debian package will install everything it needs.

## Installing

    $ curl -s https://raw.githubusercontent.com/dokku-alt/dokku-alt/master/bootstrap.sh | sudo sh

## Configuring

If you use bootstrap script from above at the end it will fireup ruby installation script. Point your browser to http://<ip>:2000/ and finish configuration.

That's it!

### Manual configuration

Set up a domain and a wildcard domain pointing to that host. Make sure `/home/dokku/VHOST` is set to this domain. By default it's set to whatever hostname the host has. This file is only created if the hostname can be resolved by dig (`dig +short $(hostname -f)`). Otherwise you have to create the file manually and set it to your preferred domain. If this file still is not present when you push your app, dokku will publish the app with a port number (i.e. `http://example.com:49154` - note the missing subdomain).

You'll have to add a public key associated with a username by doing something like this from your local machine:

    $ cat ~/.ssh/id_rsa.pub | ssh dokku.me "sudo sshcommand acl-add dokku dokku"

## Upgrade and beta releases

Unlinke `dokku` this script uses debian packaging system (deb). To upgrade to latest version simply execute: `sudo apt-get update && sudo apt-get install dokku-alt`.

Alongside the normal (stable) releases we distribute as well beta (bleeding edge). To switch to beta simply execute: `sudo apt-get update && sudo apt-get install dokku-alt-beta`. It will replace the stable dokku-alt and switch to beta.

## Migration from dokku

It should be possible, it should mostly work, but it's not tested and advised. VPS are very cheap this days so fire-up new machine and setup `dokku-alt` from the scratch.

## Deploy an App

Now you can deploy apps on your Dokku. Let's deploy the [Heroku Node.js sample app](https://github.com/heroku/node-js-sample). All you have to do is add a remote to name the app. It's created on-the-fly.

    $ git clone https://github.com/heroku/node-js-sample
    $ cd node-js-sample
    $ git remote add dokku dokku@dokku-alt.com:node-js-app
    $ git push dokku master
    Counting objects: 296, done.
    Delta compression using up to 4 threads.
    Compressing objects: 100% (254/254), done.
    Writing objects: 100% (296/296), 193.59 KiB, done.
    Total 296 (delta 25), reused 276 (delta 13)
    -----> Building node-js-app ...
           Node.js app detected
    -----> Resolving engine versions

    ... blah blah blah ...

    -----> Application deployed:
           http://node-js-app.progriumapp.com

You're done!

Right now Buildstep supports buildpacks for Node.js, Ruby, Python, [and more](https://github.com/progrium/buildstep#supported-buildpacks). It's not hard to add more, [go add more](https://github.com/progrium/buildstep#adding-buildpacks)!
Please check the documentation for your particular build pack as you may need to include configuration files (such as a Procfile) in your project root.

## Dockerfile images

The key feature of the `dokku-alt` is built-in support for Dockerfiles, the docker build process. It allows you to create more advanced and more repetitive application environments.
To use `Dockerfile` simply put `Dockerfile` in root of the application, `dokku-alt` will detect it and build application according to specification in `Dockerfile`.

Dockerfile-based application can (but not required) to expose web-application port. `dokku-alt` will check if 80, 8080, 5000 is exposed. If it's it will update assign vhost and reconfigure nginx to forward all incoming traffic.

Using dockerfile you can built service-only applications. Simply don't expose public facing ports.

Example Dockerfile application: https://github.com/ayufan/dokku-alt-phpmyadmin

## Nginx and redirects

Dokku-alt has built-in support for additional domains and url redirects. By specifying redirects any client using that address will automatically be redirected to first domain assigned to the application.

## Remote commands

Dokku commands can be run over ssh. Anywhere you would run `dokku <command>`, just run `ssh -t dokku@progriumapp.com <command>`
The `-t` is used to request a pty. It is highly recommended to do so.
To avoid the need to type the `-t` option each time, simply create/modify a section in the `.ssh/config` on the client side, as follows :

    Host progriumapp.com
    RequestTTY yes

## Run a command in the app environment

It's possible to run commands in the environment of the deployed application:

    $ dokku run node-js-app ls -alh
    $ dokku run <app> <cmd>

## Removing a deployed app

SSH onto the server, then execute:

    $ dokku delete myapp

## Environment variable management

Typically an application will require some environment variables to run properly. Environment variables may contain private data, such as passwords or API keys, so it is not recommend to store them in your application's repository.

The `config` plugin provides the following commands to manage your variables:
```
config <app> - display the config vars for an app  
config:get <app> KEY - display a config value for an app  
config:set <app> KEY1=VALUE1 [KEY2=VALUE2 ...] - set one or more config vars
config:unset <app> KEY1 [KEY2 ...] - unset one or more config vars
```

## Image tagging

When you successfully deploy an app, you can tag it with your name and later in case of failure quickly revert back to that image.

    $ dokku tag:add gitlab v6.9.0
    =====> Tagged latest image of dokku/gitlab as v6.9.0
    $ dokku tag:list gitlab
    REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
    dokku/gitlab        build               fc3baf1216d2        4 weeks ago         954.9 MB
    dokku/gitlab        latest              fc3baf1216d2        4 weeks ago         954.9 MB
    dokku/gitlab        release             fc3baf1216d2        4 weeks ago         954.9 MB
    dokku/gitlab        v6.9.0              fc3baf1216d2        4 weeks ago         954.9 MB
    $ dokku deploy gitlab release <-- it will deploy GIT head
    $ dokku deploy gitlab v6.9.0 <-- it will deploy tagged image

## Databases

Dokku-alt has built-in support for all modern database engines: MariaDB (former MySQL), PostgreSQL and MongoDB. The database image will be downloaded and provisioned when first used.

First create database:

    $ dokku mariadb:create test-db
    -----> MariaDB database created: test-db

Second link database to an app:

    $ dokku mariadb:link node-js-sample test-db
    -----> Releasing node-js-sample ...
    -----> Deploying node-js-sample ...
    -----> Shutting down old containers
    =====> Application deployed:
        http://node-js-sample.ayufan.eu

Verify application env variables:

    $ dokku config node-js-sample
    === node-js-sample config vars ===
    DATABASE_URL:  mysql2://node-js-sample:random-password@mariadb:3306/test-db

To use different database engine simple replace `mariadb` with `postgresql` or `mongodb`.

## Preboot / zero-downtime boot

Similar to functionality provided by https://devcenter.heroku.com/articles/labs-preboot `dokku-alt` supports zero-downtime. To enable zero-downtime deployment execute command: `dokku preboot:enable APP`. Alongside with preboot there's `checks` plugin based on https://labnotes.org/zero-downtime-deploy-with-dokku/. For now it simply checks if application started serving requests. If checks module fails it will not replace the application.

Preboot and checks can be configured using a few env variables:

* PREBOOT_WAIT_TIME - number of seconds to wait for container boot (default 5s)
* PREBOOT_COOLDOWN_TIME - number of seconds to wait finish container request processing (default 30s)
* DOKKU_CHECKS_WAIT - number of seconds to wait before request retries (default 10s)
* DOKKU_CHECKS_TIMEOUT - number of seconds to wait for each response (default 20s)
* DOKKU_CHECKS_RETRY - number of retries (default 3)

## TLS support

Dokku provides easy TLS support from the box. To enable TLS connection to your application, copy the `.crt` and `.key` files into the `/home/dokku/:app/ssl` folder (notice, file names should be `server.crt` and `server.key`, respectively). Redeployment of the application will be needed to apply TLS configuration. Once it is redeployed, the application will be accessible by `https://` (redirection from `http://` is applied as well).

## Help
    
    $ dokku help
    apps:disable <app>                              Disable specific app
    apps:enable <app>                               Re-enable specific app
    apps:list                                       List app
    apps:restart <app>                              Restart specific app (not-redeploy)
    apps:start <app>                                Stop specific app
    apps:status <app>                               Status of specific app
    apps:stop <app>                                 Stop specific app
    apps:top <app> [args...]                        Show running processes
    backup:export [file]                            Export dokku configuration files
    backup:import [file]                            Import dokku configuration files
    config <app>                                    display the config vars for an app
    config:get <app> KEY                            display a config value for an app
    config:set <app> KEY1=VALUE1 [KEY2=VALUE2 ...]  set one or more config vars
    config:unset <app> KEY1 [KEY2 ...]              unset one or more config vars
    delete <app>                                    Delete an application
    domains:get <app>                               Get domains for an app
    domains:redirect:get <app>                      Get redirect domains for an app
    domains:redirect:set <app> <domains...>         Set redirect app domains
    domains:set <app> <domains...>                  Set app domains
    help                                            Print the list of commands
    logs <app> [-t]                                 Show the last logs for an application (-t follows)
    mariadb:console <app> <db>                      Launch console for MariaDB container
    mariadb:create <db>                             Create a MariaDB database
    mariadb:delete <db>                             Delete specified MariaDB database
    mariadb:info <app> <db>                         Display application informations
    mariadb:link <app> <db>                         Link database to app
    mariadb:list <app>                              List linked databases
    mariadb:unlink <app> <db>                       Unlink database from app
    mongodb:console <app> <db>                      Launch console for MongoDB container
    mongodb:create <db>                             Create a MongoDB database
    mongodb:delete <db>                             Delete specified MongoDB database
    mongodb:info <app> <db>                         Display application informations
    mongodb:link <app> <db>                         Link database to app
    mongodb:list <app>                              List linked databases
    mongodb:unlink <app> <db>                       Unlink database from app
    plugins-install                                 Install active plugins
    plugins                                         Print active plugins
    postgresql:console <app> <db>                   Launch console for PostgreSQL container
    postgresql:create <db>                          Create a PostgreSQL database
    postgresql:delete <db>                          Delete specified PostgreSQL database
    postgresql:info <app> <db>                      Display application informations
    postgresql:link <app> <db>                      Link database to app
    postgresql:list <app>                           List linked databases
    postgresql:unlink <app> <db>                    Unlink database from app
    rebuild:all                                     Rebuild all apps
    rebuild <app>                                   Rebuild an app
    redis:create <app>                              Create a Redis database
    redis:delete <app>                              Delete specified Redis database
    redis:info <app>                                Display application information
    run <app> <cmd>                                 Run a command in the environment of an application
    tag:add <app> <tag>                             Tag latest running image using specified name
    tag:list <app>                                  List all image tags
    tag:rm <app> <tag>                              Tag latest running image using specified name
    url <app>                                       Show the URL for an application
    version                                         Print dokku's version

## Support

You can use [Github Issues](https://github.com/dokku-alt/dokku-alt/issues), check [Troubleshooting](https://github.com/progrium/dokku/wiki/Troubleshooting) on the wiki, or join us on [freenode in #dokku](https://webchat.freenode.net/?channels=%23dokku)

## Components

 * [Docker](https://github.com/dotcloud/docker) - Container runtime and manager
 * [Dokku](https://github.com/progrium/dokku) - Orginal Dokku instance
 * [Buildstep](https://github.com/progrium/buildstep) - Buildpack builder
 * [pluginhook](https://github.com/progrium/pluginhook) - Shell based plugins and hooks
 * [sshcommand](https://github.com/progrium/sshcommand) - Fixed commands over SSH

## License

MIT
