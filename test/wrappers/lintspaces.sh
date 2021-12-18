#!/bin/sh -e

# This script wraps the prettier command and runs it through `diff` to produce
# a more useful output (i.e., line numbers and an error message)

file="${1}"

# This program is relatively slow, so we make an exception and produce some
# progress output
echo "Checking: ${file}"

output="$(mktemp)"

# TODO: The `strip-ansi` functionality should be baked into Obelist
lintspaces \
    --editorconfig .editorconfig --matchdotfiles "${file}" 2>&1 |
    strip-ansi | sed "s,${PWD}/,," >&2

rm -rf "${output}"
