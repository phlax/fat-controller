# phlax/fat-controller
#
# VERSION       0.0.1


# Root stage
FROM debian:stretch-slim as root

MAINTAINER Ryan Northey <ryan@synca.io>

ENV DEBIAN_FRONTEND=noninteractive \
    container=docker \
    APP_DIR=/controller \
    APP_USER_ID=1000 \
    APP_USERNAME=controller

COPY controller.service /etc/systemd/system/controller.service
COPY daemon-controller.service /etc/systemd/system/daemon-controller.service
COPY configuration.service /etc/systemd/system/configuration.service
COPY install-docker.sh /tmp/install-docker.sh
COPY install-ctrl.sh /tmp/install-ctrl.sh
COPY docker-compose /usr/local/bin/docker-compose
COPY idle.timer /etc/systemd/system/idle.timer
COPY idle.service /etc/systemd/system/idle.service

RUN /tmp/install-docker.sh

COPY install-ctrl.sh /tmp/install-ctrl.sh
RUN /tmp/install-ctrl.sh

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
RUN systemctl enable controller

COPY configure-controller /usr/local/bin/configure-controller

COPY start-controller /usr/local/bin/start-controller
COPY stop-controller /usr/local/bin/stop-controller

COPY start-daemons /usr/local/bin/start-daemons
COPY stop-daemons /usr/local/bin/stop-daemons

COPY start-service /usr/local/bin/start-service
COPY wait-for-service /usr/local/bin/wait-for-service
COPY stop-service /usr/local/bin/stop-service

COPY start-proxy /usr/local/bin/start-proxy
COPY stop-idle-services /usr/local/bin/stop-idle-services
COPY controller-entry.sh /usr/local/bin/controller-entry.sh

COPY restore-from-checkpoint /usr/local/bin/restore-from-checkpoint
COPY checkpoint-service /usr/local/bin/checkpoint-service
COPY notify-service-change /usr/local/bin/notify-service-change

STOPSIGNAL 37
VOLUME [ "/sys/fs/cgroup" ]
ENTRYPOINT ["/usr/local/bin/controller-entry.sh"]
