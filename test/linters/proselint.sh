#!/bin/sh -e

. test/lib/setup/linter.sh

run_proselint() {
    test/lib/tools/find-all-files.sh |
        grep -E '\.md$' |
        xargs parallel-moreutils proselint --
}

# Using a pipe means the exit value of the first command will be ignored,
# allowing `obelist` to determine which severity level should result in an
# error
run_proselint |
    obelist parse --quiet --console --write "${lint_out}" \
        --error-on="notice" --parser="proselint" --format="txt" -
