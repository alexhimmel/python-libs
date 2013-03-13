#!/bin/bash

SITE_PACKAGE_NAME=xcp

if [[ -z $(which pylint) ]]; then
    echo "Pylint not found - Please install"
    exit 1
fi

if [[ ! -d "xcp" ]]; then
    mkdir $SITE_PACKAGE_NAME
fi

if [[ $EUID -ne 0 ]]; then
    echo "Must be run as root to bind mount"
    exit 2
fi


mount --bind ../python-libs.hg $SITE_PACKAGE_NAME

if [[ $? -ne 0 ]]; then
    echo "Mount failed"
    exit 3
fi


if [[ -z $1 ]]; then
    pylint --rcfile=pylint.rc *.py net
else
    pylint --rcfile=pylint.rc $1
fi



umount $SITE_PACKAGE_NAME
rmdir $SITE_PACKAGE_NAME --ignore-fail-on-non-empty