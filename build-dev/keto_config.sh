#!/bin/bash

declare -A KEYMAP

getAccountInfo() {
    KEY_DATA=$(/opt/keto/bin/keto_cli.sh -A | awk -F"[{}]" '{print $2}')
}

getAccountInfo
