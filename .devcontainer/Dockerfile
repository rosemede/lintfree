FROM mcr.microsoft.com/vscode/devcontainers/base:alpine

ENV PYENV_ROOT="/usr/local/pyenv"
ENV PATH="${PYENV_ROOT}/bin:${PYENV_ROOT}/shims:${PATH}"

COPY test.sh /tmp
COPY setup.sh /tmp
RUN /tmp/setup.sh
