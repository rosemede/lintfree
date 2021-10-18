#!/bin/sh -e

cd "$(dirname "$0")"

if ! which brew >/dev/null; then
    BREW_PREFIX="/home/linuxbrew/.linuxbrew"
    PATH="foo:${BREW_PREFIX}/sbin:${BREW_PREFIX}/bin:${PATH}"
fi

brew bundle

pipx install poetry

NPM_OPTS="--no-fund --no-audit --prefer-dedupe --global"

echo $NPM_OPTS

# npm install $NPM_OPTS npm
