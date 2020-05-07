#!/bin/bash -v

if [ ! -z "$TRAP_ERRORS" ]; then
    trap "$TRAP_ERRORS" ERR
fi


docker-compose up -d
docker-compose logs fatc

$FC_STATUS
$FC_STATUS -n500 configuration
$FC_STATUS fatc -p ActiveState | grep -v inactive | grep active


## main fatc service
$FC_EXEC ls -l /etc/systemd/system | rev | cut -d' ' -f1 | rev | grep '^fatc\.service' | tr '\n\r' '\n' | grep "^fatc\.service$"

## configuration service
$FC_EXEC ls -l /etc/systemd/system | rev | cut -d' ' -f1 | rev | grep '^configuration\.service' | tr '\n\r' '\n' | grep "^configuration\.service$"

## idle timer and service
$FC_EXEC ls -l /etc/systemd/system | rev | cut -d' ' -f1 | rev | grep idle

## services
$FC_EXEC ls -l /etc/systemd/system | rev | cut -d' ' -f1 | rev | grep '^fatc\.service' | tr '\n\r' '\n' | grep "\.service$" | grep -v "^fatc\.service$" | grep -v "\-\-proxy"
$FC_EXEC fatctl list-services | grep service

## service proxies
$FC_EXEC ls -l /etc/systemd/system | rev | cut -d' ' -f1 | rev | grep '^fatc\.service' | tr '\n\r' '\n' | grep "\.service$" | grep -v "^fatc\.service$" | grep "\-\-proxy.service$"

# service sockets
$FC_EXEC ls -l /etc/systemd/system | rev | cut -d' ' -f1 | rev | grep '^fatc\.service' | tr '\n\r' '\n' | grep "\.socket$"

## daemons
$FC_EXEC ls -l /etc/systemd/system | rev | cut -d' ' -f1 | rev | grep '^fatc\.daemon' | tr '\n\r' '\n' | grep "\.service$" | grep -v "\-\-proxy"
$FC_EXEC fatctl list-daemons | grep daemon

## daemon proxies
$FC_EXEC ls -l /etc/systemd/system | rev | cut -d' ' -f1 | rev | grep '^fatc\.daemon' | tr '\n\r' '\n' | grep "\.service$" | grep "\-\-proxy.service$"

## daemon sockets
$FC_EXEC ls -l /etc/systemd/system | rev | cut -d' ' -f1 | rev | grep '^fatc\.daemon' | tr '\n\r' '\n' | grep "\.socket$"

## networks
$FC_EXEC docker network ls | grep fatc_proxy
$FC_EXEC docker network inspect fatc_proxy | jq -cr '.[].IPAM.Config[].Subnet' | grep "10.0.23.0/24"

$FC_EXEC docker network ls | grep fatc_network1
$FC_EXEC docker network ls | grep fatc_network2
$FC_EXEC docker network ls | grep fatc_other_network

$FC_EXEC fatctl resolve stack http

docker-compose down
