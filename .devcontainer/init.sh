#!/bin/sh -e

cd "$(dirname "$0")"

brew bundle

pipx install poetry

NPM_OPTS="--no-fund --no-audit --prefer-dedupe --global"

echo $NPM_OPTS

# npm install $NPM_OPTS npm
