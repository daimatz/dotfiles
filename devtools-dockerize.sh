#!/bin/bash

# docker build -t devtools - < devtools.Dockerfile

bin=$HOME/bin
mkdir -p $bin
cp devtools $bin
cp docker-compose.yml $bin

function create() {
    path=$1
    docker=$2
    dockerarg=$3
    cmd=$4
    echo "$@"
    echo "#!/bin/bash" > $path
    echo "$HOME/bin/devtools \"$docker\" \"$dockerarg\" $cmd \"\$@\"" >> $path
    chmod +x $path
}

for i in \
    "docker ag -t -t '' -t" \
    "docker global -t -t '' -t" \
    "docker-compose gtags -t -t '' -t" \
    "docker jq -it -i -i -i" \
    "docker nkf -it -i -i -i" \
    "docker tig -it -it -it -it" \
    "docker scala -it -it -it -it" \
    "docker java -it -it -it -it" \
    "docker javac -it -it -it -it" \
    ; do
    create \
        $bin/$(echo "$i" | awk '{print $2}') \
        $(echo "$i" | awk '{print $1}') \
        '' \
        "$(echo "$i" | cut -f 2- -d ' ')"
done

# don't use /nfshost to avoid nfs-related issue
create $HOME/bin/go \
  "docker-compose" \
  "-e GOROOT=/root/.goroot -e GOPATH=/host$HOME -e GOOS=darwin -e GOARCH=amd64" \
  "/root/.goroot/bin/go -it -it -it -it"
create $HOME/bin/gorun \
  "docker" \
  "-e GOROOT=/root/.goroot -e GOPATH=/host$HOME" \
  "'/root/.goroot/bin/go run' -it -it -it -it"
create $HOME/bin/sbt \
  "docker-compose" \
  "" \
  "'java -Dsbt.ivy.home=/host$HOME/.ivy2 -Divy.home=/host$HOME/.ivy2 -jar /usr/share/sbt/bin/sbt-launch.jar' -it -it -it -it"
