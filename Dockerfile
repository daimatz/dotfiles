# docker build --build-arg USER=$USER -t dclaude-$USER --build-arg UID=$(id -u) --build-arg GID=$(id -g) .
FROM ubuntu:24.04

ARG USER
ARG UID
ARG GID

RUN apt update && apt install -y curl wget sudo git

# 既存のGIDがあれば再利用、なければユーザーのグループを変更
RUN set -eux; \
    if getent group "${GID}" >/dev/null; then \
        GROUP_NAME="$(getent group "${GID}" | cut -d: -f1)"; \
    elif getent group "${USER}" >/dev/null; then \
        groupmod -g "${GID}" "${USER}"; \
        GROUP_NAME="${USER}"; \
    else \
        groupadd -g "${GID}" "${USER}"; \
        GROUP_NAME="${USER}"; \
    fi; \
    \
    if id -u "${USER}" >/dev/null 2>&1; then \
        usermod -u "${UID}" -g "${GROUP_NAME}" -s /bin/bash "${USER}"; \
    elif getent passwd "${UID}" >/dev/null; then \
        EXISTING_USER="$(getent passwd "${UID}" | cut -d: -f1)"; \
        usermod -l "${USER}" -d "/home/${USER}" -m "${EXISTING_USER}"; \
        usermod -g "${GROUP_NAME}" -s /bin/bash "${USER}"; \
    else \
        useradd -m -u "${UID}" -g "${GROUP_NAME}" -s /bin/bash "${USER}"; \
    fi; \
    \
    echo "${USER} ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/${USER}"; \
    chmod 0440 "/etc/sudoers.d/${USER}"; \
    groupadd $USER; \
    sudo -u $USER mkdir -p /home/${USER}/.ssh

RUN git clone https://github.com/daimatz/env /tmp/env
RUN cd /tmp/env \
  && curl -I https://github.com/itamae-kitchen/mitamae/releases/latest \
  | grep location \
  | head -n 1 \
  | awk -F'tag/' '{print $2}' \
  | sed -e 's/\r$//' > MITAMAE_VERSION
RUN cd /tmp/env \
  && wget https://github.com/k0kubun/mitamae/releases/download/$(cat MITAMAE_VERSION)/mitamae-$(uname -m)-linux -O mitamae \
  && chmod +x mitamae \
  && ./mitamae local -j itamae/"${USER}".json itamae/base/*
RUN ln -sf /usr/bin/python3 /usr/bin/python
RUN cd

RUN curl -fsSL https://raw.githubusercontent.com/tj/n/master/bin/n | bash -s install lts
RUN npm i -g typescript typescript-language-server
RUN npm i -g @openai/codex

USER "${USER}"
ENV PATH="/home/${USER}/.local/bin:${PATH}"
RUN curl -fsSL https://claude.ai/install.sh | bash
RUN cd "/home/${USER}/dotfiles/" \
  && git submodule update --init \
  && bash linker.sh

CMD ["sleep", "infinity"]
