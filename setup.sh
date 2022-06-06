#!/bin/sh
. /opt/farm/scripts/init


mkdir -p /etc/heartbeat/hooks

if [ "$HWTYPE" != "container" ] && [ "$HWTYPE" != "lxc" ]; then
	ln -sf /opt/farm/ext/monitoring-heartbeat/hooks/smart.sh /etc/heartbeat/hooks/smart.sh
fi

/opt/farm/scripts/setup/extension.sh sf-db-utils
/opt/farm/scripts/setup/extension.sh heartbeat-linux

if grep -q /opt/farm/ext/monitoring-heartbeat/cron /etc/crontab; then
	sed -i -e "/\/opt\/farm\/ext\/monitoring-heartbeat\/cron/d" /etc/crontab
fi

if grep -q /opt/farm/ext/monitoring-smart/cron /etc/crontab; then
	sed -i -e "/\/opt\/farm\/ext\/monitoring-smart\/cron/d" /etc/crontab
fi

if grep -q /opt/farm/ext/monitoring-space/cron /etc/crontab; then
	sed -i -e "/\/opt\/farm\/ext\/monitoring-space\/cron/d" /etc/crontab
fi
