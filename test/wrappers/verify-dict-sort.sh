#!/bin/sh -e

. test/lib/setup/wrapper.sh

sort -n <"${file}" >"${output}"

test/lib/tools/process-diff.sh "${file}" "${output}"
