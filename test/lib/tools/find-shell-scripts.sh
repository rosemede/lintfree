#!/bin/sh -e

# TODO: Implement caching

# Preemptively ignore the largest directories that would be ignored by Git
find . -type "f" \
    ! -path "./.git/*" \
    ! -path "./.venv/*" \
    ! -path "./.tox/*" |
    sed 's,./,,' | sort | while read -r file; do
    # Skip any files ignored by Git
    if git check-ignore "${file}" >/dev/null; then
        continue 2
    fi
    mime_type="$(file --mime-type --brief "${file}")"
    case "${mime_type}" in
    text/x-shellscript)
        # Include all shell scripts
        echo "${file}"
        ;;
    text/plain)
        # Include files with a `shellcheck` directive on the first line
        if head -n 1 "${file}" |
            grep "# shellcheck shell" >/dev/null; then
            echo "${file}"
        fi
        ;;
    # Default NOOP
    *) ;;
    esac
done
