#!/bin/bash

# docker build -t devtools - < devtools.Dockerfile

bin=$HOME/bin
mkdir -p $bin
cp devtools $bin

for i in \
    "ag -t -t '' -t" \
    "global -t -t '' -t" \
    "gtags -t -t '' -t" \
    "jq -it -i -i -i" \
    "nkf -it -i -i -i" \
    "tig -it -it -it -it" \
    ; do
    cmd=$bin/$(echo $i | awk '{print $1}')
    echo "#!/bin/bash" > $cmd
    echo "$HOME/bin/devtools $i \$*" >> $cmd
    chmod +x $cmd
done
