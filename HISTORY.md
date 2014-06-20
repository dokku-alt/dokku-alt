# History of Dokku-alt

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
