#!/bin/bash
. /etc/farmconfig
. /opt/farm/scripts/functions.custom

services=""

check_service() {
	port=$1
	svc=$2
	if nc -z 127.0.0.1 $port >/dev/null; then
		services="$services,$svc"
	fi
}

check_service 1521 oracle
check_service 1583 pervasive
check_service 3050 firebird
check_service 3306 mysql
check_service 5432 postgres
check_service 6379 redis
check_service 8086 influxd-http
check_service 8088 influxd-rpc
check_service 9200 elasticsearch
check_service 9300 elasticcluster
check_service 11211 memcached
check_service 27017 mongodb

check_service 80 http
check_service 443 https
check_service 3128 squid
check_service 3000 app3000
check_service 3001 app3001
check_service 3002 app3002
check_service 8080 app8080

check_service 25 smtp
check_service 143 imap
check_service 993 imaps
check_service 110 pop3
check_service 995 pop3s

check_service 137 netbios-ns
check_service 138 netbios-dgm
check_service 139 netbios-ssn
check_service 445 samba

check_service 21 ftp
check_service 22 ssh
check_service 23 telnet
check_service 53 dns
check_service 111 portmap
check_service 389 ldap
check_service 631 ipp
check_service 953 rdnc
check_service 1194 openvpn
check_service 2812 monit
check_service 3260 iscsi

# https://developer.couchbase.com/documentation/server/current/install/install-ports.html
check_service 4369 cb-epmd
check_service 6060 cb-query-internal
check_service 8091 cb-rest
check_service 8092 cb-capi
check_service 8093 cb-query
check_service 8094 cb-fts
check_service 9100 cb-indexer-admin
check_service 9101 cb-indexer-scan
check_service 9102 cb-indexer-http
check_service 9105 cb-indexer-stmaint
check_service 9998 cb-xdcr-rest
check_service 9999 cb-projector
check_service 11209 cb-memcached-dedicated
check_service 11210 cb-memcached
check_service 21100 cb-internal0
check_service 21101 cb-internal1

if [ "`which docker`" != "" ]; then
	containers=`docker ps --format '{{.Names}}' 2>/dev/null |tr '\n' ','`
	if [ "$containers" != "" ]; then
		services="$services,${containers::-1}"
	fi
fi

if [ "`which virsh`" != "" ]; then
	machines=`virsh list |grep running |awk '{ print "virt-" $2 }' |tr '\n' ','`
	if [ "$machines" != "" ]; then
		services="$services,${machines::-1}"
	fi
fi

if [ "$HWTYPE" != "lxc" ]; then
	disks=`df |grep dev/mapper/disk- |sed s/0:0-//g |grep -v : |cut -d' ' -f1 |cut -d'/' -f4 |tr '[:upper:]' '[:lower:]' |tr '\n' ','`
	if [ "$disks" != "" ]; then
		services="$services,${disks::-1}"
	fi
fi

if [ -s /etc/local/.config/heartbeat.url ]; then
	url=`cat /etc/local/.config/heartbeat.url`
else
	url=`heartbeat_url`
fi

curl --connect-timeout 1 --retry 2 --retry-max-time 3 -s "$url?host=$HOST&services=${services:1}" >/dev/null 2>/dev/null
