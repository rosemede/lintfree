#!/bin/sh -e

. test/lib/setup/linter.sh

run_cspell() {
    # This program is relatively slow, so we run it in parallel
    test/lib/tools/find-all-files.sh |
        xargs cspell \
            --config ".cspell.json" --no-color --no-progress --no-summary |
        sed "s,^${PWD}/,,"
}

# Using a pipe means the exit value of the first command will be ignored,
# allowing `obelist` to determine which severity level should result in an
# error
run_cspell |
    obelist parse --quiet --console --write "${lint_out}" \
        --error-on="notice" --parser="cspell" --format="txt" -
