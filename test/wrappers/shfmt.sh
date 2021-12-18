#!/bin/sh -e

. test/lib/setup/wrapper.sh

shfmt -p -i 4 "${file}" >"${output}" || true

test/lib/tools/process-diff.sh "${file}" "${output}"
