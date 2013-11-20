dokku-user-env-complie
=====================
user-env-complie is to dokku what [user-env-complie](https://devcenter.heroku.com/articles/labs-user-env-compile) is to heroku. It essentially makes a applications ENV file available to the build container. This allows the build process to to run in an environment that more closely resembles the runtime environment.

## Installation

```sh
cd /var/lib/dokku/plugins
git clone https://github.com/musicglue/dokku-user-env-compile.git user-env-compile
dokku plugins-install
```