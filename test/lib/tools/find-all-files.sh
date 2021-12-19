#!/bin/sh -e

# TODO: Implement caching

# Preemptively ignore the largest directories that would be ignored by Git
find . -type "f" \
    ! -path "./.git/*" \
    ! -path "./.venv/*" \
    ! -path "./poetry.lock" |
    sed 's,./,,' | sort | while read -r file; do
    # Skip any files ignored by Git
    if git check-ignore "${file}" >/dev/null; then
        continue 2
    fi
    echo "${file}"
done
