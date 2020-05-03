#!/bin/bash

declare -a logs

get_logs() {
    local node=$1
    echo -e "$(docker exec compose_${node} bash -c 'cat /opt/avertem/log/avertemd_*.log')"
}

get_memory_rss() {
    local node=$1
    echo `docker exec compose_${node} bash -c "ps -o rss= -C avertemd | tr -s ' '"`
}

get_memory_vsz() {
    local node=$1
    echo `docker exec compose_${node} bash -c "ps -o vsz= -C avertemd | tr -s ' '"`
}

get_memory_vsize() {
    local node=$1
    echo `docker exec compose_${node} bash -c "ps -o vsize= -C avertemd | tr -s ' '"`
}

get_memory() {
    local node=$1
    local resident_memory_rss=`get_memory_rss ${node}`
    local resident_memory_vsz=`get_memory_vsz ${node}`
    local array=("${resident_memory_rss[0]}" "${resident_memory_vsz[@]}")
    printf "%10s\n" "${array[@]}"
}

check_state() {
    echo "$(cd $COMPOSE_DIR && docker-compose top)"
}

parse_logs() {
    local node=$1
    local expression=$2
    echo "$(echo -e "${logs[@]}" | grep "${expression}" | wc -l)"
}

node_check() {
    local node=$1
    logs="$(get_logs ${node})"
    network="$(parse_logs "${node}" "Network intialization is now complete")"
    #base_count=0
    #if [ "${network}" -gt "${base_count}" ] ; then
    #    network="connected";
    #else
    #    network="initializing";
    #fi
    block_status="$(parse_logs "${node}" "Synchronization has now been completed")"
    #if [ "${block_status}" -gt "0" ] ; then
    #    block_status="synchronized";
    #else
    #    block_status="unsynchronized";
    #fi
    producer_count="$(parse_logs "${node}" "Node is now a producer")"

    local memory_rss=`get_memory_rss "${node}"`
    local memory_vsz=`get_memory_vsz "${node}"`
    local memory_vsize=`get_memory_vsize "${node}"`
    printf "%10s %4s %4s %4s  %8s\n" ${node} ${network} ${block_status} ${producer_count} ${memory_rss}
}

check_info() {
    #logs="$(get_logs)"
    printf "%10s %4s %4s %4s %8s %8s\n" "node" "net" "stat" "prod" "RSS"
    node_check "master_1"
    node_check "node1_1"
    node_check "node2_1"
    node_check "node3_1"
    node_check "node4_1"
    node_check "readnode_1"
}


COMMAND=$1
WORK_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
COMPOSE_DIR=${WORK_DIR}/../compose/

if [ -z "${COMMAND}" ]
then
    echo "Must provide a cluster command"
    echo "  start - start the cluster."
    echo "  rebuild  - rebuild and start the cluster."
    echo "  stop  - stop the cluster."
    echo "  restart  - restart the container."
    echo "  status - status of the cluster."
    echo "  info - info of the cluster."
    echo "  logs  - attach and print the logs."
    echo "  log   - log export for a node."
    echo "  clean - clean the containers up."
    echo "  check - check if the process is running"
    exit -1
fi

CURRENT_STATE="$(check_state)"

checkForNetwork() {
    local network_name=$1
    echo $(docker network ls | grep ${network_name} | wc -l)
}

startAvertemNetwork() {
    local network_available=$(checkForNetwork avertem)
    if [ ${network_available} -eq 0 ]
    then 
    docker network create avertem
    fi
}

stopAvertemNetwork() {
    #docker network rm avertem
    echo "stop avertem network"
}

if [ "${COMMAND}" == "start" ]
then
    if [ -n "$CURRENT_STATE" ]
    then
        echo "Running"
        exit 0
    fi
    cd ${COMPOSE_DIR} && startAvertemNetwork && docker-sync start && docker-compose up -d
elif [ "${COMMAND}" == "rebuild" ]
then
    if [ -n "$CURRENT_STATE" ]
    then
        echo "Running"
        exit 0
    fi
    cd ${COMPOSE_DIR} && docker-sync start && docker-compose up --build --always-recreate-deps --force-recreate -d
elif [ "${COMMAND}" == "stop" ]
then
    cd ${COMPOSE_DIR} && docker-compose stop && docker-sync stop && stopAvertemNetwork
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
    cd ${COMPOSE_DIR} && docker-compose logs ${NODE}
elif [ "${COMMAND}" == "clean" ]
then
    cd ${COMPOSE_DIR} && docker-compose down && docker-sync clean && docker volume prune -f
elif [ "${COMMAND}" == "check" ]
then
    echo -n "${CURRENT_STATE}"
elif [ "${COMMAND}" == "info" ]
then
    check_info
else
    cd ${COMPOSE_DIR} && docker-compose "$@"
fi

