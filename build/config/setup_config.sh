#!/bin/bash


declare -A KEYMAP

getAccountInfo() {
    KEY_DATA=$(/opt/keto/bin/keto_cli.sh -A | awk -F"[{}]" '{print $2}')

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
    KETO_CONFIG=/opt/keto/config/config.ini

    echo > $KETO_CONFIG
cat << EOF >> $KETO_CONFIG
base-data-dir= var/db
# log directory
log-file=ketod_%N.log
# log level
log-level=debug
# the account hash
account-hash=${KEYMAP["account_hash"]}
# public key dir
public-key-dir=keys/ketod/public
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
block_producer_enabled=true
# rpc peer
rpc-peer=${KEYMAP["rpc_peer"]}
consensus-keys=${KEYMAP["consensus_keys"]}
peers=data/peers
# auto upgrade
check_script=upgrade/ubuntu.sh
auto_update=false
EOF
}

setCoreConfig() {
    mkdir /opt/keto/core/
    echo '/opt/keto/core/core.%h.%e.%t' > /proc/sys/kernel/core_pattern
}

getAccountInfo

if [ -n "${KETO_rpc_peer}" ] ; then
    KEYMAP["rpc_peer"]="${KETO_rpc_peer}"
else
    KEYMAP["rpc_peer"]="34.241.60.196"
fi
if [ -n "${KETO_consensus_keys}" ] ; then
    KEYMAP["consensus_keys"]="${KETO_consensus_keys}"
else
    KEYMAP["consensus_keys"]=""
fi

setKetoConfig





