#!/bin/sh -e

. test/lib/setup/wrapper.sh

lychee \
    --no-progress \
    --exclude-all-private \
    "${file}" |
    strip-ansi | sort | uniq |
    grep -E '^. [^ ]+:' |
    sed -E 's,^. ([^ ]+): .* \((.*)\) .*,\1 HTTP \2,' \
        >"${output}" || true

test/lib/tools/process-links.py "${file}" "${output}"
