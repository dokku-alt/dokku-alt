RabbitMQ Dockerfile
===================

Build
-----
```
docker build -t dokku/rabbitmq github.com/jlachowski/dokku-rabbitmq-dockerfiles.git
```

Usage
-----
Start with "admin" user and <admin password>
```
docker run -p 5672 -p 15672 -d dokku/rabbitmq /usr/bin/start-rabbitmq.sh <admin password>
```

Start with persistent database (<volume> - host directory)
```
docker run -v <volume>:/opt/rabbitmq -p 5672 -p 15672 -d dokku/rabbitmq /usr/bin/start-rabbitmq.sh <admin password>
```

TODO:
-----
- improve creation of admin user
