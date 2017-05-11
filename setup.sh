#!/bin/sh

if ! grep -q /opt/farm/ext/monitoring-heartbeat/cron/update.sh /etc/crontab; then
	echo "setting up crontab entry"
	echo "*/2 * * * * root /opt/farm/ext/monitoring-heartbeat/cron/update.sh" >>/etc/crontab
fi
