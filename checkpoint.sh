#!/bin/bash

stop=""
PYTHON_SCRIPT=""
python_args=""
sleeptime=""
id="placeholder"
nid=""
has_id="n"

DIR="/home/mpcheckpoint"
CRIU_EX="/home/mpcheckpoint/criu/criu/"
for ((i=1; i<=$#; i++)); do
    if [ "${!i}" == "-id" ]; then
        next_index=$((i + 1))
        id="${!next_index}"
        nid="${!next_index}"
        has_id="y"
    fi

    if [ "${!i}" == "-time" ]; then
        next_index=$((i + 1))
        sleeptime="${!next_index}"
        stop="-time"
    fi

    if [ "${!i}" == "-periodic" ]; then
        next_index=$((i + 1))
        sleeptime="${!next_index}"
        stop="-periodic"
    fi
    if [[ "${!i}" == *.py ]]; then
        PYTHON_SCRIPT="${!i}"
        for ((j=i+1; j<=$#; j++)); do
            python_args="${python_args} ${!j}"
        done
    fi
done

TYPE="$1"
if [ "$id" == "placeholder" ]; then
    id=${PYTHON_SCRIPT%.py}
else
    id="${PYTHON_SCRIPT%.py}_$id"
fi

mkdir -p checkpoints
mkdir -p outputs
CHECKPOINT_DIR="checkpoints/checkpoint_$id"
PID_FILE="outputs/Pid_$id"


if [[ "$TYPE" == "start" ]]; then
    setsid python3 -u "$PYTHON_SCRIPT" $python_args < /dev/null &> "outputs/output_$id.log" &
    PID=$!
    echo "$PID" > $PID_FILE
    echo "Process started with pid: $PID"
fi

if [[ "$TYPE" == "resume" ]]; then
    PID=$(<$PID_FILE)
    ${CRIU_EX}criu restore -d -v4 -o restore.log --images-dir $CHECKPOINT_DIR &
    echo "Process $PID resumed"
fi

if [[ "$TYPE" == "resume" || "$TYPE" == "start" ]]; then
    (
        if [[ "$stop" == "-time" ]]; then
            sleep $sleeptime
            if [ "$has_id" == "y" ]; then
                sudo "$DIR"/CRIUDA-Checkpoint/checkpoint.sh stop -id $nid "$PYTHON_SCRIPT"
            else
                sudo "$DIR"/CRIUDA-Checkpoint/checkpoint.sh stop "$PYTHON_SCRIPT"
            fi

        fi
    ) &

    (
        if [[ "$stop" == "-periodic" ]]; then
            sleep $sleeptime
            while kill -0 $PID 2>/dev/null; do
                if [ "$has_id" == "y" ]; then
                    sudo "$DIR"/CRIUDA-Checkpoint/checkpoint.sh stop -id $nid "$PYTHON_SCRIPT" -no-stop
                else
                    sudo "$DIR"/CRIUDA-Checkpoint/checkpoint.sh stop "$PYTHON_SCRIPT" -no-stop
                fi
                sleep $sleeptime
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
    ${CRIU_EX}criu dump -t $PID -v4 -o dump.log --images-dir $CHECKPOINT_DIR $LEAVE_RUNNING
    END=$(date +%s%N)
    DIFF=$(( (END - START) / 1000000 ))
    printf "Checkpoint saved in $CHECKPOINT_DIR in $DIFF ms\n"
fi

# sudo singularity shell --add-caps CAP_CHECKPOINT_RESTORE criud.sif
