#!/bin/bash

PYTHON_SCRIPT="$1"
CHECKPOINT_DIR="checkpoint_${PYTHON_SCRIPT%.py}" 
PID_FILE="Pid_${PYTHON_SCRIPT%.py}"


# Integrate the setsid pattern for detached, background execution
setsid python3 "$PYTHON_SCRIPT" < /dev/null &> "output.log" &

PID=$!
echo "$PID" > $PID_FILE


(
    if [[ "$2" == "-time" ]]; then
        sleep $3 
        ./stop.sh test.py 
    fi
) &

(
    if [[ "$2" == "-periodic" ]]; then
        sleep $3
        while kill -0 $PID 2>/dev/null; do    
            ./stop.sh test.py -no-stop
            sleep $3
        done 
    fi
) &


