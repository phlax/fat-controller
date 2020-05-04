#!/bin/bash -ev


if [ ! -z "$TRAP_ERRORS" ]; then
    trap $TRAP_ERRORS ERR
fi

docker-compose up -d

## Service start/stop

$FC_EXEC systemctl stop fatc.service.service0.0
$S0_STATUS -p ActiveState | grep inactive

$CURL --unix-socket ./example/sockets/fc/service0.0.sock http://localhost | grep Hello | grep backend | grep unix
$S0_STATUS -p ActiveState | grep -v inactive | grep active


# $FC_SYSTEMCTL_STATUS fatc.service.service0.0
# | grep criu-dump.log
# error_log=$($FC_SYSTEMCTL_STATUS fatc.service.service0.0 | grep criu-dump.log | cut -d" " -f26)
# cut -d/ -f2- | cut -d ' ' -f1)
# cat "${error_log::-1}"

docker-compose down
