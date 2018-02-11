#!/bin/sh

if [ -x /opt/bin/nc ] && [ ! -x /bin/nc ]; then
	ln -s /opt/bin/nc /bin/nc
fi

if ! grep -q /opt/farm/ext/monitoring-heartbeat/cron/update.sh /etc/crontab; then
	echo "setting up crontab entry"
	echo "*/2 * * * * root /opt/farm/ext/monitoring-heartbeat/cron/update.sh" >>/etc/crontab
fi
