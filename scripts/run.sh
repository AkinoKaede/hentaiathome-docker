#!/bin/sh

kill_jar() {
    echo 'Received TERM'
    killall java
    wait "$(ps -ef | pgrep java)"
    echo 'Process finished'
}

if [ $KEY ]; then
    echo -n "${KEY}" >/hath/data/data/client_login
else
    if [ ! -f /hath/data/data/client_login ]; then
        echo "Login not found."
        exit 1
    fi
fi

trap 'kill_jar' TERM INT KILL

java -jar HentaiAtHome.jar --cache-dir=/hath/data/cache \
    --data-dir=/hath/data/data \
    --download-dir=/hath/download \
    --log-dir=/hath/data/log \
    --temp-dir=/hath/data/temp \
    $* &

wait $!
