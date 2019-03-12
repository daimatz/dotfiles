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
