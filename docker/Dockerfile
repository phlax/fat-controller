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

ARG FATC_SYSTEMD=/etc/systemd/system

ARG FATC_RUN=/var/run/fatc
ARG FATC_LIB=/var/lib/fatc
ARG FATC_BIN=$FATC_LIB/bin
ARG FATC_COMPOSE=$FATC_BIN/docker-compose
ARG FATC_SOCKETS=$FATC_RUN/sockets

ARG FATC_PROXY_SOCKETS=$FATC_SOCKETS/fc
ARG FATC_DAEMONS=$FATC_LIB/daemons
ARG FATC_DAEMONS_SOCKETS=$FATC_SOCKETS/daemons
ARG FATC_SERVICES=$FATC_LIB/services
ARG FATC_SERVICES_SOCKETS=$FATC_SOCKETS/services
ARG FATC_IDLE=$FATC_RUN/idle/services

ARG FATC_USE_CRIU=true
ARG FATC_CRIU=$FATC_LIB/criu
ARG FATC_CONTAINERS=$FATC_LIB/containers

ARG FATC_TIMEOUT_SOCKETS=120
ARG FATC_TIMEOUT_IDLE=50


ENV FATC_SYSTEMD=$FATC_SYSTEMD \
	FATC_BIN=$FATC_BIN \
	FATC_COMPOSE=$FATC_COMPOSE \
	FATC_PROXY_SOCKETS=$FATC_PROXY_SOCKETS \
	FATC_SOCKETS=$FATC_SOCKETS \
	FATC_TIMEOUT_SOCKETS=$FATC_TIMEOUT_SOCKETS \
	FATC_DAEMONS=$FATC_DAEMONS \
	FATC_DAEMONS_SOCKETS=$FATC_DAEMONS_SOCKETS \
	FATC_SERVICES=$FATC_SERVICES \
	FATC_SERVICES_SOCKETS=$FATC_SERVICES_SOCKETS \
	FATC_IDLE=$FATC_IDLE \
	FATC_TIMEOUT_IDLE=$FATC_TIMEOUT_IDLE \
	FATC_USE_CRIU=$FATC_USE_CRIU \
	FATC_CRIU=$FATC_CRIU \
	FATC_CONTAINERS=$FATC_CONTAINERS

ENTRYPOINT
CMD ["/usr/bin/start-systemd"]
