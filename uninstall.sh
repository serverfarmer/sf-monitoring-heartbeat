#!/bin/sh

if grep -q /opt/farm/ext/monitoring-heartbeat/cron /etc/crontab; then
	sed -i -e "/\/opt\/farm\/ext\/monitoring-heartbeat\/cron/d" /etc/crontab
fi
