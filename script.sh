#!/bin/bash

PYTHON_SCRIPT="test.py"
CHECKPOINT_DIR="checkpoint"


python3 "$PYTHON_SCRIPT" &
PID=$!

# Function to handle SIGINT 
checkpoint() {
    echo "Checkpointing process $PID"
    mkdir -p "$CHECKPOINT_DIR"
    criu dump --shell-job --images-dir $CHECKPOINT_DIR --tree $PID
    echo "Checkpoint saved in $CHECKPOINT_DIR"
    exit 0
}

# Trap Ctrl+C 
trap checkpoint SIGINT


wait $PID

