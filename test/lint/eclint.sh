#!/bin/sh -e

# ANSI codes
DIM=[2m
RESET=[0m

eclint_all() {
    eclint -show_all_errors 2>&1 | grep -v "no such file or directory"
}

eclint_all

poetry_run() {
    if test "${GITHUB_ACTIONS:=}" = "true"; then
        if echo "::group::\$ $*"; then
            poetry run "${@}"
        else
            echo "::endgroup::"
            false
        fi
    else
        printf "\e${DIM}\$ %s\e${RESET}\n" "$*" && poetry run "$@"
    fi
}

octonote_parse() {
    eclint_all | cat
    eclint_all | poetry_run \
        octonote parse --quiet --parser editorconfig --format txt "$@"
}

if test "${SIMULATE_GITHUB:=}" = "true"; then
    # shellcheck disable=SC2310
    # https://github.com/koalaman/shellcheck/wiki/SC2310
    eclint_all >/dev/null || octonote_parse --verbose -
else
    # shellcheck disable=SC2310
    # https://github.com/koalaman/shellcheck/wiki/SC2310
    eclint_all || octonote_parse -
fi
