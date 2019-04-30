FROM ubuntu:16.04

# sync with daimatz/env

# apt-get
RUN apt-get update && \
  apt-get install -y \
    apt-transport-https \
    autoconf \
    bison \
    build-essential \
    curl \
    exuberant-ctags \
    flex \
    git \
    jq \
    libevent-dev \
    liblzo2-dev \
    libncurses5-dev \
    libpam-dev \
    libssl-dev \
    lzop \
    mercurial \
    mosh \
    nkf \
    nodejs \
    npm \
    ntp \
    openssl \
    python-pip \
    ruby \
    silversearcher-ag \
    software-properties-common \
    sqlite \
    unzip \
    vim \
    wget \
    zip \
    zsh

# global
RUN pip install Pygments && \
  cd /tmp && \
  wget http://tamacom.com/global/global-6.5.5.tar.gz && \
  tar xf global-6.5.5.tar.gz && \
  cd global-6.5.5 && \
  ./configure && make && make install

# tig
RUN cd /tmp && \
  wget http://jonas.nitro.dk/tig/releases/tig-2.0.3.tar.gz && \
  tar xf tig-2.0.3.tar.gz && \
  cd tig-2.0.3 && \
  ./configure && make && make install

# golang
RUN cd /tmp && \
  curl -L http://golang.org/dl/go1.10.linux-amd64.tar.gz | \
  tar -xz -C ~/ && \
  mv ~/go ~/.goroot

# java & scala
RUN \
  echo "deb https://dl.bintray.com/sbt/debian /" | \
  tee -a /etc/apt/sources.list.d/sbt.list && \
  add-apt-repository -y ppa:openjdk-r/ppa && \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823 && \
  apt-get update && \
  apt-get install -y openjdk-8-jdk maven scala sbt

# thrift
RUN cd /tmp && \
  wget http://archive.apache.org/dist/thrift/0.11.0/thrift-0.11.0.tar.gz && \
  tar xf thrift-0.11.0.tar.gz && \
  cd thrift-0.11.0 && \
  ./configure && make && make install

RUN ln -sf /usr/bin/nodejs /usr/bin/node
