#!/bin/bash

# Start the first process
service mysql restart
mysql -u root -e "create database xwiki default character set utf8 collate utf8_bin"
mysql -u root -e "grant all privileges on *.* to xwiki@localhost identified by 'xwiki'"
touch /usr/local/tomcat/logs/catalina.out
./bin/startup.sh
tail -f /usr/local/tomcat/logs/catalina.out