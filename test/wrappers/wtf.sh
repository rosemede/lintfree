#!/bin/sh -e

# This script wraps the prettier command and runs it through `diff` to produce
# a more useful output (i.e., line numbers and an error message)

file="${1}"

output="$(mktemp)"

wtf --quiet -E lf "${file}" >"${output}" || true

if test -s "${output}"; then
    diff "${file}" "${output}" |
        grep -E "^[0-9]" |
        sed 's/c.*//' | sed 's/d.*//' | sed 's/,/:/' |
        while read -r line; do
            echo "${file}:${line}:Incorrect whitespace"
        done
fi

rm -rf "${output}"
