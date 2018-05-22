#!/bin/bash

set -e

apt-get update
apt-get install -qq \
	--no-install-recommends \
     apt-transport-https \
     ca-certificates \
     curl \
     git \
     gnupg2 \
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
        --allow-downgrades \
        docker-ce=17.09.1~ce-0~debian

echo 'deb http://deb.debian.org/debian stretch-backports main' >> /etc/apt/sources.list
apt-get update -qq \
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

useradd \
    -m \
    -u $APP_USER_ID \
    -d /home/$APP_USERNAME \
    -k /etc/skel \
    -s /bin/bash \
  $APP_USERNAME

echo "creating app dir: $APP_DIR"
mkdir -p "$APP_DIR/src"
chown -R $APP_USERNAME:$APP_USERNAME "$APP_DIR"
