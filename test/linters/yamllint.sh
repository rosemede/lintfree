#!/bin/sh -e

. test/lib/setup/linter.sh

run_yamllint() {
    # This program is relatively slow, so we run it in parallel
    test/lib/tools/find-all-files.sh |
        grep -E '\.ya?ml$' |
        xargs parallel-moreutils yamllint --
}

# Using a pipe means the exit value of the first command will be ignored,
# allowing `obelist` to determine which severity level should result in an
# error
output="$(mktemp)"
run_yamllint | strip-ansi >"${output}"
obelist parse --quiet --console --write "${lint_out}" \
    --error-on="notice" --parser="yamllint" --format="txt" - <"${output}"
rm -f "${output}"
