#!/bin/sh -e

# This script wraps the command to produce a more useful output (i.e., line
# numbers and an error message)

file="${1}"

# This program is relatively slow, so we make an exception and print progress
# information
echo "Checking: $file"

output="$(mktemp)"

prettier --no-color --ignore-unknown "$file" >"$output" || true

if test -s "$output"; then
    diff "$file" "$output" |
        grep -E "^[0-9]" |
        sed 's/c.*//' | sed 's/,/:/' |
        while read -r line; do
            echo "$file:$line:Incorrect formatting" >&2
        done
fi

rm -rf "$output"
