#!/bin/bash


if [ ! -z "$TRAP_ERRORS" ]; then
    trap "$TRAP_ERRORS" ERR
fi

docker-compose up -d


### Daemon 0

## unix socket for daemon0 is setup and listening
$D0_STATUS.0--proxy.socket -p ActiveState | grep -v inactive | grep active
$D0_STATUS.0--proxy -p ActiveState | grep inactive
$D0_STATUS -p ActiveState | grep -v inactive | grep active
$D0_STATUS -n500 | grep STARTED
$D0_STATUS -n200 | grep HEAD

## unix socket for daemon0 is responding to http requests
$CURL --unix-socket ./example/sockets/fc/daemon0.0.sock http://localhost | grep Hello | grep backend | grep unix
$D0_STATUS.0--proxy -p ActiveState | grep -v inactive | grep active
$D0_STATUS | grep GET
$D0_COMPOSE logs http | grep GET


### Daemon 1

# unix socket for daemon1 is setup and listening,
$D1_STATUS.0--proxy.socket -p ActiveState | grep -v inactive | grep active
$D1_STATUS.0--proxy -p ActiveState | grep inactive
$D1_STATUS -n200 | grep HEAD

# unix socket for daemon1 is responding to http requests
$CURL --unix-socket ./example/sockets/fc/daemon1.0.sock http://localhost | grep Hello | grep backend | grep network
$D1_STATUS.0--proxy -p ActiveState | grep -v inactive | grep active
$D1_STATUS | grep GET
$D1_COMPOSE logs http | grep GET

### Daemon 2

## http socket for daemon2 is setup and listening
$D2_STATUS.0--proxy.socket -p ActiveState | grep -v inactive | grep active
$D2_STATUS.0--proxy -p ActiveState | grep inactive
$D2_STATUS -n200 | grep HEAD

## http socket for daemon2 is responding to http requests
$CURL http://localhost:8082 | grep Hello | grep backend | grep unix
$D2_STATUS.0--proxy -p ActiveState | grep -v inactive | grep active
$D2_STATUS | grep GET
$D2_COMPOSE logs http | grep GET


### Daemon 3

## http socket for daemon3 is setup and listening
$D3_STATUS.0--proxy.socket -p ActiveState | grep -v inactive | grep active
$D3_STATUS.0--proxy -p ActiveState | grep inactive
$D3_STATUS -n200 | grep HEAD

## http socket for daemon3 is responding to http requests
$CURL http://localhost:8083 | grep Hello | grep backend | grep network

$D3_STATUS.0--proxy -p ActiveState | grep -v inactive | grep active
$D3_STATUS | grep GET
$D3_COMPOSE logs http_daemon3 | grep GET


### Daemon 4

## isolated daemon4 is running
$D4_STATUS -p ActiveState | grep -v inactive | grep active

docker-compose down
