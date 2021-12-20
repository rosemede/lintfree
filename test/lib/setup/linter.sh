#!/bin/sh -e

lint_out="${LINT_OUT:=}"
export lint_out

no_error="${OBELIST_NO_ERROR:=}"
export silent

if test -z "${lint_out}"; then
    echo "Error: \`LINT_OUT\` not set"
    exit 1
fi

if test "${no_error}" != "true"; then
    make --no-print-directory lint-clean
fi
