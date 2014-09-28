# History of Dokku-alt

## 0.3.7

* Added integration testing using Wercker and Travis-CI (not yet fully working)
* Added `dokku create`
* Added ACL plugin: admin and deploy only keys
* Fixed MongoDB user creation
* Use `postgres` instead of `postgresql` in DATABASE_URL
* Allow to use alternative images for MariaDB, MongoDB, PostgreSQL and Redis (different server versions)
* Added plugin for easy TLS certificate management
* Added HTTP-Basic support
* Enable SPDY support and allow to use HSTS by specifying DOKKU_ENABLE_HSTS=1 for an app
* Fixed bug with data-volumes being injected during buildstep process
* Allow to configure NGINX listen address
* `X-Forwarded-For` uses `$proxy_add_x_forwarded_for`

## 0.3.6

* Added bind to 0.0.0.0 in dokku-installer.
* Added WARNING about exposing ports to outside world.
* Allow to import databases using `mariadb:console`, `postgresql:console`.
* Added `mariadb:dump`, `postgresql:dump` and `mongodb:import`, `mongodb:export`, `mongodb:dump`.
* Added -f to `dokku:logs`.
* Fixed issue with not exposing env variables during buildstep build.
* Use `docker logs` instead of `docker attach` to view output of containers during build.
* Better run method for `bootstrap.sh` script - interactive mode.
* Revoke PostgreSQL permissions on application destroy.

## 0.3.5

* Added data volumes: docker and host-based.
* Added support for config vars: PREBOOT_WAIT_TIME, PREBOOT_COOLDOWN_TIME, DOKKU_CHECKS_WAIT, DOKKU_CHECKS_TIMEOUT and DOKKU_CHECKS_RETRY.
* Renamed zero-downtime to preboot.
* Added `dokku enter` and `dokku exec` which allows you to gain interactive shell or execute command in application container.

## 0.3.4

* Buildstep uses [Foreman](https://github.com/ddollar/foreman) by default.

## 0.3.3

* Added image tagging: `dokku tags:add <app> <tag_name>; dokku deploy <app> <tag_name>`
* Added zero-downtime deployment: `dokku config:set <app> DOKKU_ZERO_DOWNTIME=1 DOKKU_WAIT_TO_RETIRE=seconds`
* Added stable and beta releases

## 0.3.2

* Added nginx `proxy_redirect` for all hostnames

## 0.3.1

* Added signed .deb
* Fixed nginx `proxy_redirect`
* Pull database images on use, not on install
* Wait for databases to boot
* Added Dockerfile to build dokku-alt based image (and run tests)

## 0.3.0

* Initial release of dokku-alt - rework of Dokku 0.3.0
