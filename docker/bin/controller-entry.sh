#!/bin/sh

mkdir -p /var/lib/controller
echo "USE_CRIU=$USE_CRIU" > /var/lib/controller/env
echo "LISTEN_ZMQ=$LISTEN_ZMQ" >> /var/lib/controller/env
echo "PUBLISH_ZMQ=$PUBLISH_ZMQ" >> /var/lib/controller/env
exec /lib/systemd/systemd $@
