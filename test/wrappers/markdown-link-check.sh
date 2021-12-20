#!/bin/sh -e

. test/lib/setup/wrapper.sh

markdown-link-check \
    --quiet \
    --config ".markdown-link-check.json" \
    "${file}" 2>&1 |
    strip-ansi | sort | uniq |
    grep -E '  .* Status: ' |
    sed -E 's,  ... ([^ ]+) . Status: ([0-9]+),\1 HTTP \2,' \
        >"${output}" || true

test/lib/tools/process-links.py "${file}" "${output}"
