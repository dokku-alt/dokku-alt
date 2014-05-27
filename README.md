# Dokku

Docker powered mini-Heroku. The smallest PaaS implementation you've ever seen.

[![Build Status](https://travis-ci.org/progrium/dokku.png?branch=master)](https://travis-ci.org/progrium/dokku)

## Requirements

Assumes that you use Ubuntu 14.04 LTS right now. Ideally have a domain ready to point to your host. It's designed for and is probably best to use a fresh VM. The debian package will install everything it needs.

## Installing

    $ curl -s https://raw.githubusercontent.com/dokku-alt/dokku-alt/master/bootstrap.sh | sudo sh

## Configuring

Set up a domain and a wildcard domain pointing to that host. Make sure `/home/dokku/VHOST` is set to this domain. By default it's set to whatever hostname the host has. This file is only created if the hostname can be resolved by dig (`dig +short $(hostname -f)`). Otherwise you have to create the file manually and set it to your preferred domain. If this file still is not present when you push your app, dokku will publish the app with a port number (i.e. `http://example.com:49154` - note the missing subdomain).

You'll have to add a public key associated with a username by doing something like this from your local machine:

    $ cat ~/.ssh/id_rsa.pub | ssh progriumapp.com "sudo sshcommand acl-add dokku dokku"

That's it!

## Deploy an App

Now you can deploy apps on your Dokku. Let's deploy the [Heroku Node.js sample app](https://github.com/heroku/node-js-sample). All you have to do is add a remote to name the app. It's created on-the-fly.

    $ cd node-js-sample
    $ git remote add progrium dokku@progriumapp.com:node-js-app
    $ git push progrium master
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

## Plugins

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

## TLS support

Dokku provides easy TLS support from the box. To enable TLS connection to your application, copy the `.crt` and `.key` files into the `/home/dokku/:app/ssl` folder (notice, file names should be `server.crt` and `server.key`, respectively). Redeployment of the application will be needed to apply TLS configuration. Once it is redeployed, the application will be accessible by `https://` (redirection from `http://` is applied as well).

## Upgrading

    $ sudo apt-get install dokku-alt

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
