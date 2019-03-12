#!/bin/bash

temp=$(mktemp -d __gtags__XXXXXXXXXXXXXXX)
gtags $* $temp
mv $temp/* .
rmdir $temp
