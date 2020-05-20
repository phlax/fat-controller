#!/bin/bash -ev


if [ ! -z "$TRAP_ERRORS" ]; then
    trap "$TRAP_ERRORS" ERR
fi


docker-compose up -d

echo "Reconfiguration tests"

$FC_EXEC systemctl stop fatc.configuration

$FC_STATUS -n500 fatc.configuration

docker-compose down
