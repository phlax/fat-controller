#!/bin/sh

mkdir -p /var/lib/controller
echo "USE_CRIU=$USE_CRIU" > /var/lib/controller/env

exec /lib/systemd/systemd $@
