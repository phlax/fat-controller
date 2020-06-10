#!/bin/bash -v

if [ ! -z "$TRAP_ERRORS" ]; then
    trap "$TRAP_ERRORS" ERR
fi


docker-compose up -d

# ensure systemd files are not populated, if they are phlax/systemd-docker needs updating

if [ -n "$($FC_EXEC ls -A /lib/systemd/system/multi-user.target.wants)" ]; then
    on_error () {
	echo "Systemd files have been re-populated, update phlax/systemd-docker"
	exit 1
    }
    on_error
fi

docker-compose logs fatc

$FC_STATUS
$FC_STATUS -n1000 fatc.configuration
$FC_STATUS -n1000 fatc
$FC_STATUS fatc -p ActiveState | grep -v inactive | grep active


## main fatc service
$FC_EXEC ls -l /etc/systemd/system | rev | cut -d' ' -f1 | rev | grep '^fatc\.service' | tr '\n\r' '\n' | grep "^fatc\.service$"

## configuration service
$FC_EXEC ls -l /etc/systemd/system | rev | cut -d' ' -f1 | rev | grep '^fatc\.configuration\.service' | tr '\n\r' '\n' | grep "^fatc\.configuration\.service$"

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
$FC_EXEC docker network inspect fatc_proxy | jq -cr '.[].IPAM.Config[].Gateway' | grep "10.0.23.7"

$FC_EXEC docker network ls | grep fatc_network1
$FC_EXEC docker network ls | grep fatc_network2
$FC_EXEC docker network ls | grep fatc_other_network

$FC_EXEC fatctl resolve stack upstream http


## volumes
$FC_EXEC ls -lh /var/run/fatc/sockets | grep testvolume | grep "drwx------"
$FC_EXEC ls -lh /var/run/fatc/sockets | grep testvolume | grep 723


## sudo permissions

$FC_EXEC su -s /bin/sh fatc -c "sudo ip route | grep docker0"
$FC_EXEC su -s /bin/sh fatc -c "sudo iptables -L | grep DOCKER-USER"


## templates

stackhash=$($FC_EXEC hashtree -i ".tpls/*" -c .tpls/ignore hash /var/lib/fatc/templates-registry/stack)
$FC_EXEC fatctl templates pull
$FC_EXEC fatctl templates list | grep "$stackhash"


## stopping
$FC_EXEC systemctl stop fatc.configuration


$FC_EXEC journalctl -l --no-pager -n500 -u fatc.*


docker-compose down
