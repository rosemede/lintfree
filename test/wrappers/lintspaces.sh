#!/bin/sh -e

. test/lib/setup/wrapper.sh

# TODO: The `strip-ansi` functionality should be baked into Obelist
lintspaces \
    --editorconfig .editorconfig --matchdotfiles "${file}" 2>&1 |
    strip-ansi | sed "s,${PWD}/,," >&2
