#!/bin/bash
# forked from https://gist.github.com/jpetazzo/5494158

su postgres sh -c "/usr/lib/postgresql/9.1/bin/postgres           -D  /var/lib/postgresql/9.1/main  -c config_file=/etc/postgresql/9.1/main/postgresql.conf  -c listen_addresses=*" 
