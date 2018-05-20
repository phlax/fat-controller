#!/bin/bash

set -e

su - controller bash -c "\
  cd /controller \
    && virtualenv -p /usr/bin/python3 . \
    && . bin/activate \
    && cd src \
    && git clone https://github.com/phlax/ctrl.core \
    && cd ctrl.core \
    && pip install -e . \
    && cd .. \
    && git clone https://github.com/phlax/ctrl.command \
    && cd ctrl.command \
    && pip install -e . \
    && cd .. \
    && git clone https://github.com/phlax/ctrl.config \
    && cd ctrl.config \
    && pip install -e . \
    && cd .. \
    && git clone https://github.com/phlax/ctrl.zmq \
    && cd ctrl.zmq \
    && pip install -e . \
    && cd .. \
    && git clone https://github.com/phlax/ctrl.compose \
    && cd ctrl.compose \
    && pip install -e . "
