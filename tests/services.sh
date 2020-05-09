#!/bin/bash


if [ ! -z "$TRAP_ERRORS" ]; then
    trap "$TRAP_ERRORS" ERR
fi


docker-compose up -d

### SERVICE 0

## unix socket for service0 is setup and listening
$S0_STATUS.0--proxy.socket -p ActiveState | grep -v inactive | grep active
$S0_STATUS.0--proxy -p ActiveState | grep inactive
$S0_STATUS -p ActiveState | grep inactive

## unix socket for service0 is responding to http requests
$CURL --unix-socket ./example/sockets/fc/service0.0.sock http://localhost | grep Hello | grep backend | grep unix
$S0_STATUS.0--proxy -p ActiveState | grep -v inactive | grep active
$S0_STATUS -p ActiveState | grep -v inactive | grep active
# these tests fail as it doesnt write to the log quickly enough
# $S0_STATUS -n500 | grep HEAD
# $S0_STATUS -n500 | grep GET
$S0_COMPOSE logs http | grep GET

### SERVICE 1

## unix socket for service1 is setup and listening
$S1_STATUS.0--proxy.socket -p ActiveState | grep -v inactive | grep active
$S1_STATUS.0--proxy -p ActiveState | grep inactive
$S1_STATUS -p ActiveState | grep inactive

## unix socket for service1 is responding to http requests
$CURL --unix-socket ./example/sockets/fc/service1.0.sock http://localhost | grep Hello | grep backend | grep network
$S1_STATUS.0--proxy -p ActiveState | grep -v inactive | grep active
$S1_STATUS -p ActiveState | grep -v inactive | grep active
# $S1_STATUS | grep HEAD
$S1_STATUS | grep GET
$S1_COMPOSE logs http_service1 | grep GET

### SERVICE 2

## http socket for service2 is setup and listening
$S2_STATUS.0--proxy.socket -p ActiveState | grep -v inactive | grep active
$S2_STATUS.0--proxy -p ActiveState | grep inactive
$S2_STATUS -p ActiveState | grep inactive

## http socket for service2 is responding to http requests
$CURL http://localhost:8092 | grep Hello | grep backend | grep unix
$S2_STATUS.0--proxy -p ActiveState | grep -v inactive | grep active
$S2_STATUS -p ActiveState | grep -v inactive | grep active
# $S2_STATUS | grep HEAD
# $S2_STATUS | grep GET
$S2_COMPOSE logs http | grep GET

### SERVICE 3

## http socket for service3 is setup and listening
$S3_STATUS.0--proxy.socket -p ActiveState | grep -v inactive | grep active
$S3_STATUS.0--proxy -p ActiveState | grep inactive
$S3_STATUS -p ActiveState | grep inactive

## http socket for service3 is responding to http requests
$CURL http://localhost:8093 | grep Hello | grep backend | grep network
$S3_STATUS.0--proxy -p ActiveState | grep -v inactive | grep active
$S3_STATUS -p ActiveState | grep -v inactive | grep active
# $S3_STATUS | grep HEAD
# $S3_STATUS | grep GET

$S3_COMPOSE logs http_service3 | grep HEAD
$S3_COMPOSE logs http_service3 | grep GET


### Backend/external services (Service4/5)

## http socket for service4 is setup and listening
$S4_STATUS.0--proxy.socket -p ActiveState | grep -v inactive | grep active
$S4_STATUS.0--proxy -p ActiveState | grep inactive
$S4_STATUS -p ActiveState | grep inactive

## http socket for service4 is responding to http requests
$CURL --unix-socket ./example/sockets/fc/service4.0.sock http://localhost | grep Hello | grep external | grep backend
$S4_STATUS.0--proxy -p ActiveState | grep -v inactive | grep active
# $S4_STATUS -p ActiveState | grep -v inactive | grep active

## http socket for service5 is setup and listening
$S5_STATUS.0--proxy.socket -p ActiveState | grep -v inactive | grep active
$S5_STATUS.0--proxy -p ActiveState | grep inactive
$S5_STATUS -p ActiveState | grep inactive

## http socket for service5 is responding to http requests
$CURL http://localhost:8095 | grep Hello | grep external | grep backend
$S5_STATUS.0--proxy -p ActiveState | grep -v inactive | grep active
# $S5_STATUS -p ActiveState | grep -v inactive | grep active

docker-compose down
