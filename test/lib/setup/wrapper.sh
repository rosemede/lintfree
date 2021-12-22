#!/bin/sh -e

file="${1}"

output="$(mktemp)"
export output

on_exit() {
    rm -f "${output}"
}

trap on_exit EXIT
