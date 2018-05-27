# phlax/fatc
#
# requires intermediate image to be built before
# this image can be built
# running:
#
#  > make image
#
# in parent folder will build this recipe
#
# VERSION       0.0.1

ARG BUILD_FROM=fc-temp

# Root stage
FROM $BUILD_FROM

MAINTAINER Ryan Northey <ryan@synca.io>

COPY dist /tmp/dist

RUN apt update \
	&& APT="apt install -y -qq \
        	--no-install-recommends \
         	--no-install-suggests" \
	&& $APT /tmp/dist/fatc_*deb \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
	&& apt-get clean

ARG SYSTEMD_DIR=/etc/systemd/system
ARG CONTROLLER_BIN=/controller/bin
ARG CONTROLLER_COMPOSE=$CONTROLLER_BIN/docker-compose
ARG CONTROLLER_SOCKETS_DIR=/var/run/controller/sockets/fc
ARG SOCKET_DIR=/var/run/controller/sockets/
ARG SOCKET_TIMEOUT=120
ARG DAEMONS_DIR=/var/lib/controller/daemons
ARG DAEMONS_SOCKET_DIR=/var/run/controller/sockets/daemons
ARG SERVICES_DIR=/var/lib/controller/services
ARG SERVICES_SOCKET_DIR=/var/run/controller/sockets/services
ARG SERVICES_IDLE=/var/run/controller/idle/services
ARG SERVICES_IDLE_TIMEOUT=50
ARG IDLE_TIMEOUT=300
ARG USE_CRIU=true
ARG CRIU_DIR=/var/lib/controller/criu
ARG CONTAINERS_DIR=/var/lib/controller/containers

ENV SYSTEMD_DIR=$SYSTEMD_DIR \
	CONTROLLER_BIN=$CONTROLLER_BIN \
	CONTROLLER_COMPOSE=$CONTROLLER_COMPOSE \
	CONTROLLER_SOCKETS_DIR=$CONTROLLER_SOCKETS_DIR \
	SOCKET_DIR=$SOCKET_DIR \
	SOCKET_TIMEOUT=$SOCKET_TIMEOUT \
	DAEMONS_DIR=$DAEMONS_DIR \
	DAEMONS_SOCKET_DIR=$DAEMONS_SOCKET_DIR \
	SERVICES_DIR=$SERVICES_DIR \
	SERVICES_SOCKET_DIR=$SERVICES_SOCKET_DIR \
	SERVICES_IDLE=$SERVICES_IDLE \
	SERVICES_IDLE_TIMEOUT=$SERVICES_IDLE_TIMEOUT \
	IDLE_TIMEOUT=$IDLE_TIMEOUT \
	USE_CRIU=$USE_CRIU \
	CRIU_DIR=$CRIU_DIR \
	CONTAINERS_DIR=$CONTAINERS_DIR

ENTRYPOINT
CMD ["/usr/bin/start-systemd"]
