#!/bin/bash

set -ex

host=$1
port=$2

if [ "$host" = "" -o "$port" = "" ]; then
    echo "Usage: $0 <host> <port>"
    exit 1
fi

while :; do
    if [ -z "$(ps aux | grep "ssh -f -N -D $port $host" | grep -v grep)" ]; then
        echo "tunneling $host:$port ..."
        ssh -f -N -D $port $host &> /dev/null || :
    fi
    sleep 5
done
