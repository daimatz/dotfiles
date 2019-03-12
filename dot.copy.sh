#!/bin/bash

# USAGE: run this script by `nohup ~/.copy.sh <host> &> /dev/null &` and write
#   function pbcopy() { cat /dev/stdin > ~/.copyfile }
# to Vagrant's .bashrc.

HOST=$1

REMOTEFILE=$HOST:.copyfile
LOCALFILE=~/.copyfile

hashcmd='gmd5sum'
checksum=`$hashcmd $LOCALFILE`
while :; do
  scp -oConnectTimeout=5 $REMOTEFILE $LOCALFILE
  if [[ ! $checksum = `$hashcmd $LOCALFILE` ]]; then
    echo "changed."
    cat $LOCALFILE
    checksum=`$hashcmd $LOCALFILE`
    pbcopy < $LOCALFILE
  fi
  sleep 1
done
