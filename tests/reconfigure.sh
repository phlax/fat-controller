#!/bin/bash -ev


if [ ! -z "$TRAP_ERRORS" ]; then
    trap "$TRAP_ERRORS" ERR
fi


docker-compose up -d

echo "Reconfiguration tests"

docker-compose down
