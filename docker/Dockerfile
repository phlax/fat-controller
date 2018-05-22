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

COPY systemd /etc/systemd/system
COPY ./install /tmp/install

RUN /tmp/install/install-docker.sh
RUN /tmp/install/install-ctrl.sh

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

COPY bin /usr/local/bin

STOPSIGNAL 37
VOLUME [ "/sys/fs/cgroup" ]
ENTRYPOINT ["/usr/local/bin/controller-entry.sh"]
