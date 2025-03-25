#!/bin/bash

PYTHON_SCRIPT="$1" #Parametro
tmp="checkpoint_$PYTHON_SCRIPT" #Parametro + default
CHECKPOINT_DIR=${tmp%.py}

checkpoint() {
    echo "Checkpointing process $PID"
    mkdir -p "$CHECKPOINT_DIR"
    criu dump --shell-job --images-dir $CHECKPOINT_DIR --tree $PID #--leave-running
    echo "Checkpoint saved in $CHECKPOINT_DIR"
    exit 0
}


first_execution(){
    mkdir "$CHECKPOINT_DIR"
    python3 "$PYTHON_SCRIPT" &
    PID=$!

    # Trap Ctrl+C 
    trap checkpoint SIGINT

    wait $PID
}

restore(){
    echo "Program resumed."

    criu restore --shell-job --images-dir $CHECKPOINT_DIR

    trap checkpoint SIGINT
}

[ ! -d "./$CHECKPOINT_DIR" ] && first_execution
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