export DIR=/home/andrea/checkpoint

start() {
    "$DIR"/ML-Restart/checkpoint.sh start "$@"
}

stop() {
    "$DIR"/ML-Restart/checkpoint.sh stop "$@"
}

resume() {
    "$DIR"/ML-Restart/checkpoint.sh resume "$@"
}
