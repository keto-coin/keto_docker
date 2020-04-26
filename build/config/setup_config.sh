#!/bin/bash


declare -A KEYMAP
KETO_PRODUCER_ENABLED="true"

getAccountInfo() {
    KEY_DATA=$(/opt/avertem/bin/avertem_cli.sh -A | awk -F"[{}]" '{print $2}')

    #set -f                      # avoid globbing (expansion of *).
    array=(${KEY_DATA//,/ })
    for i in "${!array[@]}"
    do
        key_value=(${array[i]//:/ })
        #echo "$i=>${key_value[0]} : ${key_value[1]}"
        key=${key_value[0]//\"}
        #echo "Key value"
        value=${key_value[1]//\"}

        # setup the key map
        eval env_keto_val='$'KETO_"$key"
        if [ -n "${env_keto_val}" ] ; then
            KEYMAP[${key}]="${env_keto_val}"
        else
            KEYMAP[${key}]="$value"
        fi
    done
}

setKetoConfig() {
    KETO_CONFIG=/opt/avertem/config/config.ini

    echo > $KETO_CONFIG
cat << EOF >> $KETO_CONFIG
base-data-dir= var/db
# log directory
log-file=avertemd_%N.log
# log level
log-level=info
# the account hash
account-hash=${KEYMAP["account_hash"]}
# public key dir
public-key-dir=keys/avertemd/public
# server public and private key
server-private-key=${KEYMAP["private_key"]}
server-public-key=${KEYMAP["public_key"]}
# block chain files
block_meta_index=data/block_meta_index
blocks=data/blocks
transactions=data/transactions
accounts=data/accounts
childs=data/childs
accounts_mapping=data/accounts_mapping
nested=data/nested
# key store
key_store=data/key_store
# graph configuration
graph_base_dir=data/graph_base_dir
# router
routes=data/routes
# genesis
genesis_config=config/genesis.json
# default block
default_block=false
block_producer_enabled=${KETO_PRODUCER_ENABLED}
block_producer_safe_mode=false
# rpc peer
rpc-peer=${KEYMAP["rpc_peer"]}
consensus-keys=${KEYMAP["consensus_keys"]}
peers=data/peers
# auto upgrade
check_script=upgrade/ubuntu.sh
auto_update=false
# network protocol
network_protocol_delay=10
network_protocol_count=10
faucet_account=D594F22DC389E38B3DE7FA5630DBD9DCA16DA8A77097516FD37F9E25C6BE24D2
EOF

if [ -n "${KETO_IS_MASTER}" ] ; then
cat << EOF >> $KETO_CONFIG
# master
is_master=true
is_network_session_generator=true
master_password=123456
master-public-key=keys/avertemd/master/public_key.pem
master-private-key=keys/avertemd/master/private_key.pem
network_fee_ratio=1
network_session_length=120
network_consensus_heartbeat=60
EOF
fi
}

setCoreConfig() {
    mkdir /opt/avertem/core/
    echo '/opt/avertem/core/core.%h.%e.%t' > /proc/sys/kernel/core_pattern
}

getAccountInfo

if [ -z "${KETO_rpc_peer}" ] ; then
    KEYMAP["rpc_peer"]="34.241.60.196"
elif [ "${KETO_rpc_peer}" == "EMPTY" ] ; then
    KEYMAP["rpc_peer"]=""
else
    KEYMAP["rpc_peer"]="${KETO_rpc_peer}"
fi
if [ -n "${KETO_consensus_keys}" ] ; then
    KEYMAP["consensus_keys"]="${KETO_consensus_keys}"
else
    KEYMAP["consensus_keys"]=""
fi

if [ -n "${PRODUCER_ENABLED}" ] ; then
    KETO_PRODUCER_ENABLED="${PRODUCER_ENABLED}"
fi

setKetoConfig

echo "Set the configuration"
cat /opt/avertem/config/config.ini
