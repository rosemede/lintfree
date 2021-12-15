#!/bin/sh -e

lint_out="${LINT_OUT:=}"

if test -z "${lint_out}"; then
    echo "Error: \`LINT_OUT\` not set"
    exit 1
fi

ec -no-color || true

# Using a pipe means the exit value of the first command will be ignored,
# allowing `obelist` to determine which severity level should result in an
# error
ec -no-color |
    obelist parse --quiet --write "${lint_out}" \
        --error-on="notice" --parser "ec" --format "txt" -
