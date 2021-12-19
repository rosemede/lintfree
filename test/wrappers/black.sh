#!/bin/sh -e

. test/lib/setup/wrapper.sh

cat "${file}" >"${output}"
black --quiet --config "pyproject.toml" "${output}" || true

test/lib/tools/process-diff.sh "${file}" "${output}"
