#!/bin/sh -e

. test/lib/setup/wrapper.sh

markdown-link-check \
    --quiet --config ".markdown-link-check.json" "${file}" \
    >"${output}" 2>&1 || true

# Copy the file so we can delete lines as we match them later on
file_copy="$(mktemp)"
cat "${file}" >"${file_copy}"

# Sort the URLs in reverse order so we can delete the longer URLs first when
# multiple URLs share the same prefix
grep -E '\[.\] .* Status' <"${output}" | sort -r | while read -r line; do
    url="$(echo "${line}" | sed 's,^\[.\] ,,' | sed 's, .*,,')"
    status="$(echo "${line}" | sed 's,^\[.\] ,,' | sed 's,.* ,,')"
    grep -n "${url}" "${file_copy}" | while read -r line; do
        line_number="$(echo "${line}" | sed 's,:.*,,')"
        echo "${file}:${line_number} ${status} ${url}" >&2
        # Replace the line with an empty line so that we can't match it again
        # without altering the line numbers
        sed -i "${line_number}s,.*,," "${file_copy}"
    done
done
