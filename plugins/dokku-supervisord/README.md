# dokku-supervisord

dokku-supervisord is a plugin for [dokku][dokku] that injects
[supervisord][super] to run applications. It will convert a normal Procfile to
supervisord.conf format when starting the application.

Normally, dokku only runs the `web` process within Procfile. The
dokku-supervisord plugin will run all process types (web, worker, etc.) and
will restart crashed applications.

## Installation

```sh
git clone https://github.com/statianzo/dokku-supervisord.git /var/lib/dokku/plugins/dokku-supervisord
```

All future deployments will use supervisord to start all processes.

## Docker 0.10 support

dokku-supervisord v0.3.0 changed the expected namespace from "app" to "dokku"
to support Docker 0.10. See details within the [dokku issue][docker10]. If
you're using a dokku version from before [this commit][docker10commit], stick
with v0.2.x of dokku-supervisord.

## License

The MIT License (MIT)

Copyright (c) 2013-2014 Jason Staten

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

[dokku]: https://github.com/progrium/dokku
[super]: http://supervisord.org
[docker10]: https://github.com/progrium/dokku/issues/533
[docker10commit]: https://github.com/progrium/dokku/commit/2474844856ab5c53398005ebc455eb53676ac5d5
