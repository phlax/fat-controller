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
	docker build -t phlax/fatc docker

hub-image:
	docker push phlax/fatc

pysh:
	pip install -U pip setuptools termcolor
	pip install -e 'git+https://github.com/phlax/pysh#egg=pysh.test&subdirectory=pysh.test'

cli:
	pip install -e 'git+https://github.com/phlax/fc.cli#egg=fc.cli&subdirectory=fc.cli'
