#!/bin/bash -ev


if [ ! -z "$TRAP_ERRORS" ]; then
    trap "$TRAP_ERRORS" ERR
fi


docker-compose up -d


## containers and networks are there
containers=$($FC_EXEC docker ps -q)
test -n "$containers"
networks=$($FC_EXEC docker network ls | grep fatc)
test -n "$networks"


## stop fatc.configuration - all containers/networks disappear
$FC_EXEC systemctl stop fatc.configuration
containers=$($FC_EXEC docker ps -q)
test -z "$containers"
networks=$($FC_EXEC docker network ls | grep fatc || exit 0)
test -z "$networks"


## start fatc again - all containers/networks back up
$FC_EXEC systemctl start fatc
containers=$($FC_EXEC docker ps -q)
test -n "$containers"
networks=$($FC_EXEC docker network ls | grep fatc)
test -n "$networks"


## restart fatc.configuration - all containers/networks come back
existing=$($FC_EXEC docker ps -q)
$FC_EXEC systemctl restart fatc.configuration
sleep 2
containers=$($FC_EXEC docker ps -q)
test -n "$containers"
networks=$($FC_EXEC docker network ls | grep fatc)
test -n "$networks"


## reload fatc.configuration - all containers/networks stay up
existing=$($FC_EXEC docker ps -q)
$FC_EXEC systemctl reload fatc.configuration
containers=$($FC_EXEC docker ps -q)
test -n "$containers"
networks=$($FC_EXEC docker network ls | grep fatc)
test -n "$networks"
# all the same containers
echo "$existing" | grep "$containers"


## update fatc.configuration - add/remove stacks
daemons=$(jq '.daemons + {daemon0a: .daemons.daemon0} | del(.daemon0) | del(.daemon2)' example/etc/config.json)
services=$(jq '.services + {service0a: .services.service0} | del(.service0) | del(.service2)' example/etc/config.json)

jq --argjson daemons "$daemons" \
   --argjson services "$services" \
   '.daemons = $daemons | .services = $services' \
   example/etc/config.json | sponge example/etc/config.json

$FC_EXEC systemctl reload fatc.configuration

## removed services/daemons
unitfiles=$($FC_EXEC find /etc/systemd/system -name "fatc.daemon.daemon0\.*")
service=$($FC_EXEC docker ps -q -f "name=daemon_daemon0_")
test -z "$unitfiles"
test -z "$service"

unitfiles=$($FC_EXEC find /etc/systemd/system -name "fatc.daemon.daemon2\.*")
service=$($FC_EXEC docker ps -q -f "name=daemon_daemon2_")
test -z "$unitfiles"
test -z "$service"

unitfiles=$($FC_EXEC find /etc/systemd/system -name "fatc.service.service0\.*")
service=$($FC_EXEC docker ps -q -f "name=service_service0_")
test -z "$unitfiles"
test -z "$service"

unitfiles=$($FC_EXEC find /etc/systemd/system -name "fatc.service.service2\.*")
service=$($FC_EXEC docker ps -q -f "name=service_service2_")
test -z "$unitfiles"
test -z "$service"


## added services/daemons - service stacks are not started
unitfiles=$($FC_EXEC find /etc/systemd/system -name "fatc.daemon.daemon0a\.*")
service=$($FC_EXEC docker ps -q -f "name=daemon_daemon0a_")
test -n "$unitfiles"
test -n "$service"

unitfiles=$($FC_EXEC find /etc/systemd/system -name "fatc.service.service0a\.*")
service=$($FC_EXEC docker ps -q -f "name=service_service0a_")
test -n "$unitfiles"
test -z "$service"


docker-compose down
