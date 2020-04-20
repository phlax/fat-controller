#!/usr/bin/make -f

SHELL := /bin/bash


deb:
	mkdir -p docker/dist
	docker run -ti -e RUN_UID=`id -u` -v `pwd`:/home/bob/build phlax/debian-build bash -c "\
	  cd build \
	  && debuild -b \
	  && cp -a ../*deb docker/dist"

image: deb
	mkdir build -p
	chmod 777 build
	source .docker-app \
	   && if [ -f .env ]; then source .env; fi \
	   && if [ ! -z "$$BUILD_FROM" ]; then docker pull $$BUILD_FROM; fi \
	   && docker build \
	         -t fc-temp \
		 --build-arg APP_NAME="$$APP_NAME" \
		 --build-arg APP_USERNAME="$$APP_USERNAME" \
		 --build-arg BUILD_IMAGE="$$BUILD_IMAGE" \
		 --build-arg BUILD_FROM="$$BUILD_FROM" \
		 --build-arg APP_DIR="$$APP_DIR" \
		 --build-arg DEB_REPOS="$$DEB_REPOS" \
		 --build-arg GPG_KEYS="$$GPG_KEYS" \
		 --build-arg EGGS="$$EGGS" \
		 --build-arg BUILD_PKGS="$$BUILD_PKGS" \
		 --build-arg SYSTEM_PKGS="$$SYSTEM_PKGS" \
		 --build-arg APP_CONFIG="$$APP_CONFIG" \
		$$BUILD_CONTEXT \
	   && docker build -t $$BUILD_IMAGE docker \
	   && docker rmi fc-temp

hub-image:
	source .docker-app \
	   && if [ -f .env ]; then source .env; fi \
	   && docker push $$BUILD_IMAGE

pysh:
	pip install -U pip setuptools termcolor
	pip install -e 'git+https://github.com/phlax/pysh#egg=pysh.test&subdirectory=pysh.test'

cli:
	pip install -e 'git+https://github.com/phlax/fc.cli#egg=fc.cli&subdirectory=fc.cli'
