#!/bin/bash

set -e

apt-get update
apt-get install -qq \
     --no-install-recommends \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get install -qq --no-install-recommends docker-ce

useradd \
    -m \
    -u $APP_USER_ID \
    -d /home/$APP_USERNAME \
    -k /etc/skel \
    -s /bin/bash \
  $APP_USERNAME

echo "creating app dir: $APP_DIR"
mkdir -p "$APP_DIR"
chown -R $APP_USERNAME:$APP_USERNAME "$APP_DIR"
