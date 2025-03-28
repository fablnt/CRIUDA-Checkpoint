#!/bin/bash

PYTHON_SCRIPT="$1" 
CHECKPOINT_DIR="checkpoint_${PYTHON_SCRIPT%.py}" # Remove .py from the filename
PID_FILE="Pid_${PYTHON_SCRIPT%.py}"

checkpoint() {
    local pid=$(<$PID_FILE)

    echo "Checkpointing process $PID"
    mkdir -p "$CHECKPOINT_DIR"
    criu dump -t $pid -v4 -o dump.log --images-dir $CHECKPOINT_DIR  #--leave-running
    echo "Checkpoint saved in $CHECKPOINT_DIR"
    echo "Press Enter to terminate"
    exit 0
}   


first_execution() {
    # Integrate the setsid pattern for detached, background execution
    setsid python3 "$PYTHON_SCRIPT" < /dev/null &> "output.log" &

    PID=$!
    # Save PID to Pid.txt
    echo "$PID" > $PID_FILE

    trap checkpoint SIGINT

    wait $PID
}

restore(){
    echo "Program resumed."

    criu restore -d -v4 -o restore.log --images-dir $CHECKPOINT_DIR & 
    echo OK 

    trap checkpoint SIGINT

    wait $(<$PID_FILE)
}



[ ! -d "./$CHECKPOINT_DIR" ] && first_execution && exit 0
[ -d "./$CHECKPOINT_DIR" ] && restore
# python3 "$PYTHON_SCRIPT" &
# PID=$!

# # Function to handle SIGINT 
# checkpoint() {
#     echo "Checkpointing process $PID"
#     mkdir -p "$CHECKPOINT_DIR"
#     criu dump --shell-job --images-dir $CHECKPOINT_DIR --tree $PID
#     echo "Checkpoint saved in $CHECKPOINT_DIR"
#     exit 0
# }

# # Trap Ctrl+C 
# trap checkpoint SIGINT


# wait $PID


# sudo singularity shell --add-caps CAP_CHECKPOINT_RESTORE criud.sif
# criu restore --shell-job --images-dir checkpoint

# snakemake nextflow