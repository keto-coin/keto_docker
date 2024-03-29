#!/bin/bash


declare -A KEYMAP
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

getAccountInfo

KETO_CONFIG=/opt/avertem/config/config.ini

cat << EOF > $KETO_CONFIG
base-data-dir= var/db
# log directory
log-file=avertem_%N.log
# log level
log-level=debug
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
nested=data/nested
parents=data/parents
accounts_mapping=data/accounts_mapping
# key store
key_store=data/key_store
# graph configuration
graph_base_dir=data/graph_base_dir
# router
routes=data/routes
# genesis
#genesis_config=config/genesis.json
# default block
default_block=false
block_producer_enabled=false
# rpc peer
rpc-peer=34.241.60.196
# auto upgrade
check_script=upgrade/ubuntu.sh
auto_update=true
faucet_account=D594F22DC389E38B3DE7FA5630DBD9DCA16DA8A77097516FD37F9E25C6BE24D2
EOF

