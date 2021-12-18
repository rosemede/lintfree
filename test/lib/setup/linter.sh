#!/bin/sh -e

lint_out="${LINT_OUT:=}"
export lint_out

silent="${SILENT:=}"
export silent

if test -z "${lint_out}"; then
    echo "Error: \`LINT_OUT\` not set"
    exit 1
fi

if test "${silent}" != "true"; then
    make --no-print-directory lint-clean
fi

on_exit() {
    if test "${silent}" != "true"; then
        make --no-print-directory lint-process
    fi
}

trap on_exit EXIT
