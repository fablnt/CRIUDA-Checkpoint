#!/bin/bash

PYTHON_SCRIPT="$1"
CHECKPOINT_DIR="checkpoint_${PYTHON_SCRIPT%.py}" 
PID_FILE="Pid_${PYTHON_SCRIPT%.py}"

pid=$(<$PID_FILE)
LEAVE_RUNNING=""
if [[ "$2" == "-no-stop" ]]; then
    LEAVE_RUNNING="--leave-running"
fi

echo "Checkpointing process $PID"
mkdir -p "$CHECKPOINT_DIR"
criu dump -t $pid -v4 -o dump.log --images-dir $CHECKPOINT_DIR $LEAVE_RUNNING #--leave-running
echo "Checkpoint saved in $CHECKPOINT_DIR"

