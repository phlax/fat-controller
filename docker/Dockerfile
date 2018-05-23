# phlax/fat-controller
#
# VERSION       0.0.1

ARG BUILD_FROM=phlax/systemd

# Root stage
FROM $BUILD_FROM

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

RUN systemctl enable controller

COPY bin /usr/local/bin
ENTRYPOINT ["/usr/local/bin/controller-entry.sh"]
