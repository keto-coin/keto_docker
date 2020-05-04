#!/bin/bash

IMAGE=$1
VERSION_NUMBER=$2

if [ -z "$IMAGE" ] ;
then
    echo "Must select the appropriate debian action"
    echo "   build - the build image"
    exit -1
elif [ -z "$VERSION_NUMBER" ] ;
then
    echo "Must select the appropriate debian version"
    echo "   version - the version number"
    exit -1
fi

WORK_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
COMPOSE_DIR=${WORK_DIR}/../compose-debian/

if [ "${IMAGE}" == "build" ] ;
then
    cd ${WORK_DIR}/../build-debian/ && docker build --no-cache -f Dockerfile . -t avertem/avertem-image
    cd ${COMPOSE_DIR} && VERSION_NUMER=$VERSION_NUMBER docker-compose up
fi
