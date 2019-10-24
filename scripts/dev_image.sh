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

if [ "${IMAGE}" == "build" ] ;
then
    cd ${WORK_DIR}/../build-build/ && docker build --no-cache -f Dockerfile . -t keto/keto-coin-dev
fi
