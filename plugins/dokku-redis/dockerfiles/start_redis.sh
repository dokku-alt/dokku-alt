#!/bin/bash

# Start redis with our custom configuration
exec /usr/bin/redis-server /etc/redis/redis.conf
