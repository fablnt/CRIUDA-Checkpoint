#!/bin/bash

PYTHON_SCRIPT="$1"
CHECKPOINT_DIR="checkpoint_${PYTHON_SCRIPT%.py}" 


criu restore -d -v4 -o restore.log --images-dir $CHECKPOINT_DIR & 
echo OK 


(
    if [[ "$2" == "-time" ]]; then
        sleep $3 
        ./stop.sh test.py 
    fi
) &