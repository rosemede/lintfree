#!/bin/sh -e

. test/lib/setup/linter.sh

run_black() {
    # This program is relatively slow, so we run it in parallel
    test/lib/tools/find-all-files.sh |
        grep -E '\.py$' |
        xargs parallel-moreutils test/wrappers/reorder-python-imports.sh --
}

# Using a pipe means the exit value of the first command will be ignored,
# allowing `obelist` to determine which severity level should result in an
output="$(mktemp)"
run_black 2>"${output}"
obelist parse --quiet --console --write "${lint_out}" \
    --error-on="notice" --parser="reorder-python-imports" --format="txt" - \
    <"${output}"
rm -f "${output}"
