#!/bin/bash -v

if [ ! -z "$TRAP_ERRORS" ]; then
    trap "$TRAP_ERRORS" ERR
fi


docker-compose up -d
docker-compose logs fatc

$FC_STATUS
$FC_STATUS -n500 configuration
$FC_STATUS controller -p ActiveState | grep -v inactive | grep active

# $FC_EXEC ls /etc/systemd/system

## main controller service
$FC_EXEC ls /etc/systemd/system | grep '^controller\.service' | tr '\n\r' '\n' | grep "^controller\.service$"

## configuration service
$FC_EXEC ls /etc/systemd/system | grep '^configuration\.service' | tr '\n\r' '\n' | grep "^configuration\.service$"

## idle timer and service
$FC_EXEC ls /etc/systemd/system | grep idle

## services
$FC_EXEC ls /etc/systemd/system | grep '^controller\.service' | tr '\n\r' '\n' | grep "\.service$" | grep -v "^controller\.service$" | grep -v "\-\-proxy"

## service proxies
$FC_EXEC ls /etc/systemd/system | grep '^controller\.service' | tr '\n\r' '\n' | grep "\.service$" | grep -v "^controller\.service$" | grep "\-\-proxy.service$"

# service sockets
$FC_EXEC ls /etc/systemd/system | grep '^controller\.service' | tr '\n\r' '\n' | grep "\.socket$"

## daemons
$FC_EXEC ls /etc/systemd/system | grep '^controller\.daemon' | tr '\n\r' '\n' | grep "\.service$" | grep -v "\-\-proxy"

## daemon proxies
$FC_EXEC ls /etc/systemd/system | grep '^controller\.daemon' | tr '\n\r' '\n' | grep "\.service$" | grep "\-\-proxy.service$"

## daemon sockets
$FC_EXEC ls /etc/systemd/system | grep '^controller\.daemon' | tr '\n\r' '\n' | grep "\.socket$"

docker-compose down
