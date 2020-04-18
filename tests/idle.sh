#!/bin/bash -ev

if [ ! -z "$TRAP_ERRORS" ]; then
    trap "$TRAP_ERRORS" ERR
fi


docker-compose up -d

echo "Idle tests"

docker-compose down
