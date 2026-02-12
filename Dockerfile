# docker build --build-arg USER=$USER -t dclaude-$USER --build-arg UID=$(id -u) --build-arg GID=$(id -g) .
FROM ubuntu:24.04

ARG USER
ARG UID
ARG GID

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
RUN ln -sf /usr/bin/python3 /usr/bin/python
RUN cd

# 既存のGIDがあれば再利用、なければユーザーのグループを変更
RUN set -eux; \
  if getent group "${GID}" >/dev/null; then \
    EXISTING_GROUP="$(getent group "${GID}" | cut -d: -f1)"; \
    usermod -g "${EXISTING_GROUP}" "${USER}"; \
  else \
    groupmod -g "${GID}" "${USER}" || true; \
  fi; \
  usermod -u "${UID}" "${USER}"; \
  # HOME 等の所有権を合わせる（必要に応じて範囲調整）
  chown -R "${UID}:${GID}" "/home/${USER}"

RUN curl -fsSL https://raw.githubusercontent.com/tj/n/master/bin/n | bash -s install lts
RUN npm i -g typescript typescript-language-server
RUN npm i -g @openai/codex
RUN hostname "dclaude-$USER"

USER "$USER"
ENV PATH="/home/$USER/.local/bin:${PATH}"
RUN curl -fsSL https://claude.ai/install.sh | bash
RUN cd "/home/$USER/dotfiles/" \
  && git submodule update --init \
  && bash linker.sh

CMD ["sleep", "infinity"]
