#!/bin/bash

TYPE="$1"
PYTHON_SCRIPT="$2"
CHECKPOINT_DIR="checkpoint_${PYTHON_SCRIPT%.py}" 
PID_FILE="Pid_${PYTHON_SCRIPT%.py}"


if [[ "$TYPE" == "start" ]]; then
    setsid python3 -u "$PYTHON_SCRIPT" < /dev/null &> "output.log" &
    PID=$!
    echo "$PID" > $PID_FILE
    echo "Process started with pid: $PID"
fi

if [[ "$TYPE" == "resume" ]]; then
    PID=$(<$PID_FILE)
    criu restore -d -v4 -o restore.log --images-dir $CHECKPOINT_DIR & 
    echo "Process $PID resumed"
fi

if [[ "$TYPE" == "resume" || "$TYPE" == "start" ]]; then
    (
        if [[ "$3" == "-time" ]]; then
            sleep $4 
            ./checkpoint.sh stop test.py 
        fi
    ) &

    (
        if [[ "$3" == "-periodic" ]]; then
            sleep $4
            while kill -0 $PID 2>/dev/null; do    
                ./checkpoint.sh stop test.py -no-stop
                sleep $4
            done 
        fi
    ) &
fi

if [[ "$TYPE" == "stop" ]]; then
    PID=$(<$PID_FILE)
    LEAVE_RUNNING=""
    if [[ "$3" == "-no-stop" ]]; then
        LEAVE_RUNNING="--leave-running"
    fi

    echo -e "\nCheckpointing process $PID"
    mkdir -p "$CHECKPOINT_DIR"    

    START=$(date +%s%N)
    criu dump -t $PID -v4 -o dump.log --images-dir $CHECKPOINT_DIR $LEAVE_RUNNING
    END=$(date +%s%N)
    DIFF=$(( (END - START) / 1000000 ))
    printf "Checkpoint saved in $CHECKPOINT_DIR in $DIFF ms\n"
fi

# sudo singularity shell --add-caps CAP_CHECKPOINT_RESTORE criud.sif
# snakemake nextflow    