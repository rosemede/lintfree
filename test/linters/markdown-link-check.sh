#!/bin/sh -e

. test/lib/setup/linter.sh

run_markdown_link_check() {
    # This program is relatively slow, so we run it in parallel
    test/lib/tools/find-all-files.sh |
        grep -E '\.md$' |
        xargs parallel-moreutils test/wrappers/markdown-link-check.sh --

}

# Using a pipe means the exit value of the first command will be ignored,
# allowing `obelist` to determine which severity level should result in an
# error
output="$(mktemp)"
run_markdown_link_check 2>"${output}"
obelist parse --quiet --console --write "${lint_out}" \
    --error-on="notice" --parser="markdown-link-check" --format="txt" - \
    <"${output}"
rm -f "${output}"
