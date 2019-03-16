#!/bin/bash

# docker build -t devtools - < devtools.Dockerfile

bin=$HOME/bin
mkdir -p $bin
cp devtools $bin

function create() {
    path=$1
    cmd=$2
    echo "#!/bin/bash" > $path
    echo "$HOME/bin/devtools $cmd \$*" >> $path
    chmod +x $path
}

for i in \
    "ag -t -t '' -t" \
    "global -t -t '' -t" \
    "gtags -t -t '' -t" \
    "jq -it -i -i -i" \
    "nkf -it -i -i -i" \
    "tig -it -it -it -it" \
    "scala -it -it -it -it" \
    "java -it -it -it -it" \
    "javac -it -it -it -it" \
    ; do
    create $bin/$(echo $i | awk '{print $1}') "$i"
done

create $HOME/bin/go "'GOROOT=~/.goroot GOPATH=/host$HOME GOOS=darwin GOARCH=amd64 ~/.goroot/bin/go' -it -it -it -it"
create $HOME/bin/gorun "'GOROOT=~/.goroot GOPATH=/host$HOME ~/.goroot/bin/go run' -it -it -it -it"
create $HOME/bin/sbt "'SBT_OPTS=\"-Xms512M -Xmx8192M -Xss2M -XX:MaxMetaspaceSize=2048M\" java -Dsbt.ivy.home=/host$HOME/.ivy2 -Divy.home=/host$HOME/.ivy2 -jar /usr/share/sbt/bin/sbt-launch.jar' -it -it -it -it"
