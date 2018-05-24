#!/bin/bash

set -e

apt-get update
apt-get install -y -qq \
	--no-install-recommends \
	--no-install-suggests \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     git \
     software-properties-common
apt-get dist-upgrade -yy -q
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get install -qq -y \
        --no-install-recommends \
	--no-install-suggests \
        --allow-downgrades \
        docker-ce=17.09.1~ce-0~debian

usermod -l $APP_USERNAME app
mv /app $APP_DIR
