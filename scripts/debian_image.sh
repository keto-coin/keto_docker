#!/bin/bash

IMAGE=$1

if [ -z "$IMAGE" ] ;
then
    echo "Must select the appropriate IMAGE"    
    echo "   build - the build image"
    echo "   dev - the dev image"
    exit -1
fi

WORK_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
COMPOSE_DIR=${WORK_DIR}/../compose-debian/

if [ "${IMAGE}" == "build" ] ;
then
    cd ${WORK_DIR}/../build-debian/ && docker build --no-cache -f Dockerfile . -t avertem/avertem-image
    cd ${COMPOSE_DIR} && docker-compose up
fi
