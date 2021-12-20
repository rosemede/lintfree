#!/bin/sh -e

. test/lib/setup/linter.sh

run_lychee() {
    # This program is relatively slow, so we run it in parallel
    test/lib/tools/find-all-files.sh |
        grep -vE '\.md$' |
        xargs parallel-moreutils test/wrappers/lychee.sh --
}

# Using a pipe means the exit value of the first command will be ignored,
# allowing `obelist` to determine which severity level should result in an
# error
output="$(mktemp)"
run_lychee 2>"${output}"
obelist parse --quiet --console --write "${lint_out}" \
    --error-on="notice" --parser="lychee" --format="txt" - <"${output}"
rm -f "${output}"
