#!/bin/bash

_term() {
  echo "Caught SIGTERM signal!"
  for pid in ${pid_array[*]}; do
     echo "Wait for ${pid}"
     kill -TERM "${pid}" 2>/dev/null
  done
}

echo "Setup the configuration"
setup_output=$(/opt/avertem/setup_config.sh)
setup_result=$?

echo "Result ${setup_result} output ${setup_output}"

trap _term SIGTERM HUP INT QUIT TERM

echo "After setting up the termination handlers"

echo "Confirm configration changes"
cat /opt/avertem/config/config.ini 

#echo "Tail the log files"
#tail -f /opt/avertem/log/avertem_* &
#tail_pid=$!
#echo "Tail started with pid of ${tail_pid}"

echo "Start Avertem"
/opt/avertem/bin/avertemd.sh &
avertem_pid=$!
echo "Avertem started with a PID of ${avertem_pid}"

pid_array=(${avertem_pid})

#if [ -n "${KETO_TAIL}" ] ; then
#    tail -f /dev/null
#else
    for pid in ${pid_array[*]}; do
        echo "Wait for ${pid}"
        wait $pid
    done
#fi
