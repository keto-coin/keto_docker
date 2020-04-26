#!/bin/bash

declare -A KEYMAP

getAccountInfo() {
    KEY_DATA=$(/opt/keto/bin/avertem_cli.sh -A | awk -F"[{}]" '{print $2}')
}

getAccountInfo
