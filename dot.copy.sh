#!/bin/bash

# USAGE: run this script by `nohup ~/.copy.sh &> /dev/null &` and write
#   function pbcopy() { cat /dev/stdin > /vagrant/.copyfile }
# to Vagrant's .bashrc.

FILE=~/.copyfile
hashcmd='ls -l'
checksum=`$hashcmd $FILE`
while :; do
  if [[ ! $checksum = `$hashcmd $FILE` ]]; then
    echo "changed."
    cat $FILE
    checksum=`$hashcmd $FILE`
    pbcopy < ~/.copyfile
  fi
  sleep 1
done
