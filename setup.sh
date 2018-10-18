#!/bin/sh
. /opt/farm/scripts/init


conditional_move() {
	oldfile=$1
	newfile=$2

	if [ -f $oldfile ] && [ ! -f $newfile ]; then
		mv $oldfile $newfile
	fi
}


mkdir -p /etc/heartbeat/hooks

if [ "$HWTYPE" != "container" ] && [ "$HWTYPE" != "lxc" ]; then
	ln -sf /opt/farm/ext/monitoring-heartbeat/hooks/smart.sh /etc/heartbeat/hooks/smart.sh
fi

conditional_move /etc/local/.config/skip-smart.devices      /etc/heartbeat/skip-smart.sata
conditional_move /etc/local/.config/skip-smart.raid         /etc/heartbeat/skip-smart.raid
conditional_move /etc/local/.config/allowed.smart           /etc/heartbeat/known-smart-defects.conf
conditional_move /etc/local/.config/heartbeat.url           /etc/heartbeat/server.url
conditional_move /etc/local/.config/raid.drives             /etc/heartbeat/detected-raid-drives.conf
conditional_move /etc/local/.config/space-check.directories /etc/heartbeat/detected-data-directories.conf

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
