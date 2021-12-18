#!/bin/sh -e

. test/lib/setup/wrapper.sh

prettier --no-color --ignore-unknown "${file}" >"${output}" || true

test/lib/tools/process-diff.sh "${file}" "${output}"
