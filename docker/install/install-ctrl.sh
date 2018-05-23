#!/bin/bash

set -e

su - controller bash -c "\
  cd /controller \
    && virtualenv -p /usr/bin/python3 . \
    && . bin/activate \
    && cd src/ctrl.core \
    && pip install -e . \
    && cd ../ctrl.command \
    && pip install -e . \
    && cd ../ctrl.config \
    && pip install -e . \
    && cd ../ctrl.systemd \
    && pip install -e . \
    && cd .. \
    && git clone https://github.com/phlax/ctrl.zmq \
    && cd ctrl.zmq \
    && pip install -e . \
    && cd .. \
    && git clone https://github.com/phlax/ctrl.compose \
    && cd ctrl.compose \
    && pip install -e . "

rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
