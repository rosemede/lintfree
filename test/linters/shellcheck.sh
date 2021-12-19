#!/bin/sh -e

. test/lib/setup/linter.sh

run_shellcheck() {
    # Echo output to the temporary file so filenames are separated by newlines,
    # avoiding the problem of needing NULL bytes to avoid problems with
    # filenames containing spaces
    tmp_file="$(mktemp)"
    test/lib/tools/find-shell-scripts.sh >"${tmp_file}"
    xargs shellcheck --color="always" --format="checkstyle" <"${tmp_file}"
    rm "${tmp_file}"
}

# Using a pipe means the exit value of the first command will be ignored,
# allowing `obelist` to determine which severity level should result in an
# error
run_shellcheck |
    obelist parse --quiet --console --write "${lint_out}" \
        --error-on="notice" --parser="shellcheck" --format="checkstyle" -
