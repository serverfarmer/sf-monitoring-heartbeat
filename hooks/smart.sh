#!/bin/sh

file=$1

if [ -d /opt/farm/ext/monitoring-cacti ]; then
	/opt/farm/ext/monitoring-cacti/cron/send.sh $file
fi
