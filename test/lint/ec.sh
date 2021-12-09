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
      if file -b --mime-encoding "$file" | grep -q "binary"; then
        continue 2
      fi
      echo "$file" | sed -E 's/^\.\///'
    done
}

run_ec() {
  output="${1}"
  # This program is relatively slow, so we run it in parallel
  # TODO: Perhaps the name of `parallel-moreutils` configurable?
  find_files |
    xargs parallel-moreutils ec -no-color -- >>"$output"
}

# Using a pipe means the exit value of the first command will be ignored,
# allowing `softener` to determine which severity level should result in an
# error
output="$(mktemp)"
#shellcheck disable=SC2310
run_ec "$output" || true
softener parse --quiet --write "$lint_out" \
  --error-on="notice" --parser="ec" --format="txt" - <"$output"
rm -f "$output"
