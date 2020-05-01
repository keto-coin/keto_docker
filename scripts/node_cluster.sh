#!/bin/bash

NODE=$1

if [ -z "$NODE" ] ;
then
    echo "Must select the appropriate NODE"    
    echo "   spawn - spawn"
    exit -1
fi

WORK_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
COMPOSE_DIR=${WORK_DIR}/../compose-node/

if [ "${NODE}" == "spawn" ] ;
then
    #DATE=`date`
    #NODE_ID=`echo $DATE | cksum | cut -f1 -d" "`
    #cd ${COMPOSE_DIR} && NODE_ID=$NODE_ID docker-compose up
    cd ${COMPOSE_DIR} && docker-compose down && docker-compose build --no-cache && docker-compose up
elif [ "${NODE}" == "build" ] ;
then
    #DATE=`date`
    #NODE_ID=`echo $DATE | cksum | cut -f1 -d" "`
    #cd ${COMPOSE_DIR} && NODE_ID=$NODE_ID docker-compose up
    cd ${COMPOSE_DIR} && docker-compose down && docker-compose build --no-cache
fi
