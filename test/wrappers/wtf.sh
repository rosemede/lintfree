#!/bin/sh -e

. test/lib/setup/wrapper.sh

wtf --quiet -E lf "${file}" >"${output}" || true

test/lib/tools/process-diff.sh "${file}" "${output}"
