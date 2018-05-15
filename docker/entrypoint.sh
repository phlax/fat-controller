#!/bin/bash


export HOME=/home/$APP_USERNAME
exec gosu $APP_USERNAME "$@"
