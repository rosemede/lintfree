#!/bin/sh -e

. test/lib/setup/wrapper.sh

reorder-python-imports \
    --application-directories=.:src - <"${file}" >"${output}" || true

test/lib/tools/process-diff.sh "${file}" "${output}"
