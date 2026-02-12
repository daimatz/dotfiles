# docker build --build-arg USER=xxx -t dclaude-xxx .
FROM ubuntu:24.04

ARG USER

RUN apt update && apt install -y curl wget sudo git
RUN git clone https://github.com/daimatz/env /tmp/env
RUN cd /tmp/env \
  && curl -I https://github.com/itamae-kitchen/mitamae/releases/latest \
  | grep location \
  | head -n 1 \
  | awk -F'tag/' '{print $2}' \
  | sed -e 's/\r$//' > MITAMAE_VERSION
RUN cd /tmp/env \
  && wget https://github.com/k0kubun/mitamae/releases/download/$(cat MITAMAE_VERSION)/mitamae-aarch64-linux -O mitamae \
  && chmod +x mitamae \
  && ./mitamae local -j itamae/"$USER".json itamae/adduser.rb \
  && ./mitamae local -j itamae/"$USER".json itamae/base/*
RUN cd

RUN curl -fsSL https://raw.githubusercontent.com/tj/n/master/bin/n | bash -s install lts
RUN npm i -g typescript typescript-language-server

USER "$USER"
RUN git config --global --add safe.directory /mnt/src/github.com
RUN curl -fsSL https://claude.ai/install.sh | bash \
  && echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc

CMD ["sleep", "infinity"]
