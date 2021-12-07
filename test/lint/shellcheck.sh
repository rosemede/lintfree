#!/bin/sh -e

# ANSI codes
DIM=[2m
RESET=[0m

# Create a temporary file so that we don't have to find files twice
tmp_file=$(mktemp)

# Find all files in the current directory, skipping the largest directories
# that would be ignored by Git
find_files() {
    find . -type f ! -path "./.git/*" ! -path "./.venv/*"
}

# Find shell script files
find_sh_files() {
    find_files | while read -r file; do
        # Skip any files ignored by Git
        if git check-ignore "$file" >/dev/null; then
            continue 2
        fi
        # Check the file MIME type
        case $(file --brief --mime-type "$file") in
        # Handle shell script files
        "text/x-shellscript")
            # Append all files
            echo "$file"
            ;;
            # Handle plain text files
        "text/plain")
            # Append all files with a shellcheck directive on the first line
            if head -n 1 "$file" | grep "# shellcheck shell" >/dev/null; then
                echo "$file"
            fi
            ;;
        # Default case
        *)
            # NOOP
            ;;
        esac
    done
}

# Cache the output
find_sh_files >"$tmp_file"

shellcheck_all() {
    xargs shellcheck --color=always --format "${1}" <"$tmp_file"
}

poetry_run() {
    if test "${GITHUB_ACTIONS:=}" = "true"; then
        if echo "::group::\$ $*"; then
            poetry run "${@}"
        else
            echo "::endgroup::"
            false
        fi
    else
        printf "\e$DIM\$ %s\e$RESET\n" "$*" && poetry run "$@"
    fi
}

softener_parse() {
    shellcheck_all json | poetry_run \
        softener parse --quiet --parser shellcheck --format json "$@"
}

if test "${SIMULATE_GITHUB:=}" = "true"; then
    # shellcheck disable=SC2310
    # https://github.com/koalaman/shellcheck/wiki/SC2310
    shellcheck_all tty >/dev/null || softener_parse --verbose -
else
    # shellcheck disable=SC2310
    # https://github.com/koalaman/shellcheck/wiki/SC2310
    shellcheck_all tty || softener_parse -
fi

# Clean up
rm -f "$tmp_file"
