#!/bin/bash


echo "Setup the configuration"
setup_output=$(/opt/keto/setup_config.sh)
setup_result=$?

echo "Result ${setup_result} output ${setup_output}"


echo "Confirm configration changes"
cat /opt/keto/config/config.ini 

echo "Tail the log files"
tail -f /opt/keto/log/ketod_* &
tail_pid=$!
echo "Tail started with pid of ${tail_pid}"

echo "Start keto"
/opt/keto/bin/ketod.sh &
ketod_pid=$!
echo "Keto started with a PID of ${ketod_pid}"

pid_array=(${tail_pid} ${ketod_pid})

for pid in ${pid_array[*]}; do
    echo "Wait for ${pid}"
    wait $pid
done
