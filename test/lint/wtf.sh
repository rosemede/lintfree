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
    find . -type "f" ! -path "./.git/*" ! -path "./.venv/*" |
        while read -r file; do
            # Skip any files ignored by Git
            if git check-ignore "${file}" >/dev/null; then
                continue 2
            fi
            echo "${file}"
        done
}

run_wtf() {
    # Echo output to the temporary file so filenames are seperated by newlines,
    # avoiding the problem of needing NULL bytes to avoid problems with
    # filenames containing spaces
    tmp_file="$(mktemp)"
    find_files >"${tmp_file}"
    while read -r file; do
        test/wrappers/wtf.sh "${file}"
    done <"${tmp_file}"
    rm "${tmp_file}"
}

# Using a pipe means the exit value of the first command will be ignored,
# allowing `obelist` to determine which severity level should result in an
# error
run_wtf |
    obelist parse --quiet --console --write "${lint_out}" \
        --error-on="notice" --parser="wtf" --format="txt" -
