#!/bin/sh -e

. test/lib/setup/linter.sh

CSPELL_CONF=".cspell.json"
CSPELL_DICT=".cspell.txt"

. test/lib/setup/linter.sh

verify_dict_sort() {
    test/wrappers/verify-dict-sort.sh "${CSPELL_DICT}" >/dev/null
}

verify_dict_entries() {
    words="$(mktemp)"
    source="$(mktemp)"
    cat --number "${CSPELL_DICT}" >"${words}"
    # Cache a list of all unique tokens found in the source files to speed up
    # search
    test/lib/tools/find-all-files.sh |
        grep -v "${CSPELL_DICT}" |
        xargs cat | tr ' ' '\n' | sort | uniq >"${source}"
    # Verify that all words in the dictionary are found in the source list
    while read -r input; do
        line="$(echo "${input}" | awk '{print $1}')"
        word="$(echo "${input}" | awk '{print $2}')"
        if test "${word}" = ""; then
            echo "${CSPELL_DICT}:${line}: Empty line" >&2
            continue
        fi
        message="Word not found in source files"
        grep -rsi "${word}" "${source}" >/dev/null ||
            echo "${CSPELL_DICT}:${line}: ${message}: ${word}" >&2
    done <"${words}"
    rm -f "${words}" "${source}"
}

run_cspell() {
    # This program is relatively slow, so we run it in parallel
    test/lib/tools/find-all-files.sh |
        xargs cspell \
            --config "${CSPELL_CONF}" --no-color --no-progress --no-summary |
        sed "s,^${PWD}/,," >&2
}

# Using a pipe means the exit value of the first command will be ignored,
# allowing `obelist` to determine which severity level should result in an
output="$(mktemp)"
verify_dict_sort 2>"${output}"
obelist parse --quiet --console --write "${lint_out}" \
    --error-on="notice" --parser="cspell" --format="sort" - \
    <"${output}"
rm -f "${output}"

# Using a pipe means the exit value of the first command will be ignored,
# allowing `obelist` to determine which severity level should result in an
# error
output="$(mktemp)"
verify_dict_entries 2>"${output}"
obelist parse --quiet --console --write "${lint_out}" \
    --error-on="notice" --parser="cspell" --format="entries" - \
    <"${output}"
rm -f "${output}"

# Using a pipe means the exit value of the first command will be ignored,
# allowing `obelist` to determine which severity level should result in an
# error
output="$(mktemp)"
run_cspell 2>"${output}"
obelist parse --quiet --console --write "${lint_out}" \
    --error-on="notice" --parser="cspell" --format="output" - <"${output}"
rm -f "${output}"
