# translate/pootle:base
#
# VERSION       0.0.1

FROM debian:stretch-slim

MAINTAINER Ryan Northey <ryan@synca.io>

ENV DEBIAN_FRONTEND=noninteractive \
    container=docker \
    APP_DIR=/controller \
    APP_USER_ID=1000 \
    APP_USERNAME=controller


COPY install-docker.sh /tmp/install-docker.sh
COPY docker-compose /usr/local/bin/docker-compose

RUN /tmp/install-docker.sh

RUN echo 'deb http://deb.debian.org/debian stretch-backports main' >> /etc/apt/sources.list
RUN apt-get update -qq \
    && apt-get install \
        -y \
        -qq \
        --no-install-recommends \
	-t stretch-backports \
        python-minimal \
        python-setuptools \
        systemd \
        virtualenv \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && apt-get clean

RUN cd /lib/systemd/system/sysinit.target.wants/; ls | grep -v systemd-tmpfiles-setup | xargs rm -f $1 \
    rm -rf /lib/systemd/system/multi-user.target.wants/*;\
    rm -rf /etc/systemd/system/*.wants/*;\
    rm -rf /lib/systemd/system/local-fs.target.wants/*; \
    rm -rf /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -rf /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -rf /lib/systemd/system/basic.target.wants/*;\
    rm -rf /lib/systemd/system/anaconda.target.wants/*; \
    rm -rf /lib/systemd/system/plymouth*; \
    rm -rf /lib/systemd/system/systemd-update-utmp*;
RUN systemctl set-default multi-user.target

USER controller
RUN cd /controller && virtualenv . && . bin/activate && pip install docker-compose
USER root

VOLUME [ "/sys/fs/cgroup" ]
ENTRYPOINT ["/lib/systemd/systemd"]
