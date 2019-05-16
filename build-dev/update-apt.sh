#!/bin/bash
set -o pipefail
exec {fd}>&2 # copy stderr to some unused fd
apt-get update -y -q 2>&1 | tee /dev/fd/$fd | ( ! grep -q -e '^Err:' -e '^[WE]:' )
result=$?
exec {fd}>&- # close file descriptor
