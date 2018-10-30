#!/bin/sh

file=$1
base=`basename $file .txt`

type=`echo $base |cut -d- -f1`
device=`echo $base |cut -d- -f2-`

if [ "$type" = "ata" ] && [ -s /etc/local/.config/newrelic.license ]; then
	/opt/farm/ext/monitoring-heartbeat/targets/sata-newrelic.sh $device $file
fi

if [ -d /opt/farm/ext/monitoring-cacti ]; then
	/opt/farm/ext/monitoring-cacti/cron/send.sh $file
fi
