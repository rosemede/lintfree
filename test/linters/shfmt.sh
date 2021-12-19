#!/bin/sh -e

. test/lib/setup/linter.sh

run_shfmt() {
    # Echo output to the temporary file so filenames are separated by newlines,
    # avoiding the problem of needing NULL bytes to avoid problems with
    # filenames containing spaces
    tmp_file="$(mktemp)"
    test/lib/tools/find-shell-scripts.sh >"${tmp_file}"
    while read -r file; do
        test/wrappers/shfmt.sh "${file}"
    done <"${tmp_file}"
    rm "${tmp_file}"
}

# Using a pipe means the exit value of the first command will be ignored,
# allowing `obelist` to determine which severity level should result in an
# error
run_shfmt 2>&1 >/dev/null |
    obelist parse --quiet --console --write "${lint_out}" \
        --error-on="notice" --parser="shfmt" --format="txt" -
