# History of Dokku-alt

## BETA

* Allow to import databases using `mariadb:console`, `postgresql:console`.
* Added `mariadb:dump`, `postgresql:dump` and `mongodb:import`, `mongodb:export`, `mongodb:dump`.
* Added -f to `dokku:logs`.

## 0.3.5

* Added data volumes: docker and host-based.
* Added support for config vars: PREBOOT_WAIT_TIME, PREBOOT_COOLDOWN_TIME, DOKKU_CHECKS_WAIT, DOKKU_CHECKS_TIMEOUT and DOKKU_CHECKS_RETRY.
* Renamed zero-downtime to preboot. 

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
