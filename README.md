## Overview

`sf-monitoring-heartbeat` Server Farmer extension is responsible for:

- installing and configuring Server Farmer Heartbeat (see https://github.com/serverfarmer/heartbeat-linux and https://github.com/serverfarmer/heartbeat-server for details)
- enabling SMART reporting to Cacti through [`sf-monitoring-cacti`](https://github.com/serverfarmer/sf-monitoring-cacti) (if it is also installed)
