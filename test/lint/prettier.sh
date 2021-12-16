#!/bin/sh -e

lint_out="${LINT_OUT:=}"

if test -z "$lint_out"; then
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
            if git check-ignore "$file" >/dev/null; then
                continue 2
            fi
            echo "$file" | sed -E 's/^\.\///'
        done
}

# Shut up `parallel`
echo "will cite" | parallel --citation 2>/dev/null

run_prettier_all() {
    file_list="$(mktemp)"
    find_files >"$file_list"
    # The `prettier` program is relatively slow, so we run it in parallel
    parallel -k test/wrappers/prettier.sh <"$file_list"
    rm -f "$file_list"
}

# Using a pipe means the exit value of the first command will be ignored,
# allowing `obelist` to determine which severity level should result in an
# error
output="$(mktemp)"
run_prettier_all 2>"$output"
obelist parse --quiet --console --write "$lint_out" \
    --error-on="notice" --parser="prettier" --format="txt" - <"$output"
rm -f "$output"
