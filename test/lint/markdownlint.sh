#!/bin/sh -e

lint_out="${LINT_OUT:=}"

if test -z "${lint_out}"; then
    echo "Error: \`LINT_OUT\` not set"
    exit 1
fi

# Using a pipe means the exit value of the first command will be ignored,
# allowing `obelist` to determine which severity level should result in an
# error
markdownlint . 2>&1 |
    obelist parse --quiet --console --write "${lint_out}" \
        --error-on="notice" --parser "markdownlint" --format "txt" -
