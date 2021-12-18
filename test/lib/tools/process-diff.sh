#!/bin/sh -e

file="${1}"
output="${2}"

if test -s "${output}"; then
    diff "${file}" "${output}" |
        grep -E "^[0-9]" |
        sed 's/c.*//' | sed 's/d.*//' | sed 's/,/:/' |
        while read -r line; do
            echo "${file}:${line}:Incorrect formatting" >&2
        done
fi
