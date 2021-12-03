#!/bin/sh -e

lint_out="${LINT_OUT:=}"

if test -z "${lint_out}"; then
    echo "Error: \`LINT_OUT\` not set"
    exit 1
fi

# Find elibible files in the current directory, skipping the largest
# directories that would be ignored by Git
find_files() {
    # Preemptively ignore the largest directories that would be ignored by Git
    find . -type "f" ! -path "./.git/*" ! -path "./.venv/*" | sort |
        while read -r file; do
            # Skip any files ignored by Git
            if git check-ignore "${file}" >/dev/null; then
                continue 2
            fi
            if file -b --mime-encoding "${file}" | grep -q "binary"; then
                continue 2
            fi
            echo "${file}" | sed -E 's/^\.\///'
        done
}

run_prettier() {
    output="${1}"
    # This program is relatively slow, so we run it in parallel
    find_files |
        xargs parallel-moreutils test/wrappers/prettier.sh -- 2>"${output}"
}

# Using a pipe means the exit value of the first command will be ignored,
# allowing `softener` to determine which severity level should result in an
# error
output="$(mktemp)"
run_prettier "${output}"
softener parse --quiet --write "${lint_out}" \
    --error-on="notice" --parser="prettier" --format="txt" - <"${output}"
rm -f "${output}"
