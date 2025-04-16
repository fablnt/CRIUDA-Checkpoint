export DIR=/home/mpcheckpoint

start() {
    sudo "$DIR"/CRIUDA-Checkpoint/checkpoint.sh start "$@"
}

stop() {
    sudo "$DIR"/CRIUDA-Checkpoint/checkpoint.sh stop "$@"
}

resume() {
    sudo "$DIR"/CRIUDA-Checkpoint/checkpoint.sh resume "$@"
}
