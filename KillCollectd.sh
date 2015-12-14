#!/bibn/bash

kill $(ps aux | grep 'collectd' | awk '{print $2}')
`/etc/init.d/collectd restart`
