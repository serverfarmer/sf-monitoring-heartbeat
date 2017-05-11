#!/bin/bash
. /opt/farm/scripts/init
. /opt/farm/scripts/functions.custom

services=""

check_service() {
	port=$1
	svc=$2
	if nc -z 127.0.0.1 $port; then
		services="$services,$svc"
	fi
}

check_service 1521 oracle
check_service 1583 pervasive
check_service 3050 firebird
check_service 3306 mysql
check_service 5432 postgres

check_service 80 http
check_service 443 https

check_service 25 smtp
check_service 143 imap
check_service 993 imaps
check_service 110 pop3
check_service 995 pop3s

check_service 21 ftp
check_service 22 ssh
check_service 53 dns
check_service 111 portmap
check_service 953 rdnc
check_service 2812 monit
check_service 11211 memcached

url=`heartbeat_url`
curl --connect-timeout 1 -s "$url?host=$HOST&services=${services:1}" |grep -v ^ok$
