#!/bin/sh -e

. test/lib/setup/linter.sh

run_misspell() {
    # This program is relatively slow, so we run it in parallel
    test/lib/tools/find-all-files.sh |
        xargs parallel-moreutils misspell -locale US --
}

# Using a pipe means the exit value of the first command will be ignored,
# allowing `obelist` to determine which severity level should result in an
# error
run_misspell |
    obelist parse --quiet --console --write "${lint_out}" \
        --error-on="notice" --parser="misspell" --format="txt" -
