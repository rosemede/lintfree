#!/bin/sh -e

lint_out="${LINT_OUT:=}"
silent="${SILENT:=}"

if test -z "${lint_out}"; then
    echo "Error: \`LINT_OUT\` not set"
    exit 1
fi

if test "${silent}" != "true"; then
    make --no-print-directory lint-clean
fi

# Find elibible files in the current directory, skipping the largest
# directories that would be ignored by Git
find_files() {
    # Preemptively ignore the largest directories that would be ignored by Git
    find . -type "f" -name '*.md' |
        sed 's,./,,' | sort | while read -r file; do
        # Skip any files ignored by Git
        if git check-ignore "${file}" >/dev/null; then
            continue 2
        fi
        echo "${file}"
    done
}
run_markdown_link_check() {
    # Run this command sequentially to avoid tripping up any rate limiting
    find_files | while read -r file; do
        test/wrappers/markdown-link-check.sh "${file}"
    done
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

if test "${silent}" != "true"; then
    make --no-print-directory lint-process
fi
