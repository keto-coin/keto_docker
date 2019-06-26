#!/bin/bash

check_state() {
    echo "$(cd $COMPOSE_DIR && docker-compose top)"
}

COMMAND=$1
WORK_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
COMPOSE_DIR=${WORK_DIR}/../compose/

if [ -z "${COMMAND}" ]
then
    echo "Must provide a cluster command"
    echo "  start - start the cluster."
    echo "  stop  - stop the cluster."
    echo "  status - status of the cluster."
    echo "  logs  - attach and print the logs."
    echo "  log   - log export for a node."
    echo "  clean - clean the containers up."
    echo "  check - check if the process is running"
    exit -1
fi

CURRENT_STATE="$(check_state)"

if [ "${COMMAND}" == "start" ]
then
    if [ -n "$CURRENT_STATE" ]
    then
        echo "Running"
        exit 0
    fi
    cd ${COMPOSE_DIR} && docker-sync start && docker-compose up -d
elif [ "${COMMAND}" == "stop" ]
then
    cd ${COMPOSE_DIR} && docker-compose stop && docker-sync stop
elif [ "${COMMAND}" == "status" ]
then
    cd ${COMPOSE_DIR} && docker-compose ps
elif [ "${COMMAND}" == "log" ]
then
    NODE=$2
    if [ -z "${NODE}" ]
    then
        echo "Must provide the node to export the logs for"
        echo "  log <node>"
        exit -1
    fi
    cd ${COMPOSE_DIR} && docker-compose logs | grep ${NODE} | cut -d"|" -f2-
elif [ "${COMMAND}" == "clean" ]
then
    cd ${COMPOSE_DIR} && docker-compose down && docker-sync clean
elif [ "${COMMAND}" == "check" ]
then
    echo -n "${CURRENT_STATE}"
else
    cd ${COMPOSE_DIR} && docker-compose "$@"
fi

