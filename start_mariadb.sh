#!/bin/bash

mysqld & tailf /var/log/mysql.log
