#!/bin/sh -e

# This script wraps the command to produce a more useful output (i.e., line
# numbers and an error message)

file="${1}"

# This program is relatively slow, so we make an exception and print progress
# information
echo "Checking: $file"

output="$(mktemp)"

lychee --no-progress "$file" 2>/dev/null |
  # Deal with the ridiculous output from the `lychee` program
  cut -b 5- | grep ": " | sort | uniq | sed "s,: , ," |
  while read -r line; do
    url="$(echo "$line" | cut -d " " -f 1)"
    message="$(echo "$line" | cut -d " " -f 2-)"
    grep -nE "$url" "$file" | cut -d ":" -f 1 | while read -r n; do
      echo "$file:$n: $message" >>"$output"
    done
  done

# Attempt to filter out multiple matches which share the same URL prefix by
# favoring longer error messages as the best match
python >&2 <<EOF
annotations = {}
with open("${output}") as file:
    for line in file.readlines():
        location, message = line.split(": ", 1)
        prev_message = annotations.get(location, "")
        if len(message) > len(prev_message):
            annotations[location] = message
for location, message in annotations.items():
    print(f"{location}: {message}".strip())
EOF

rm -f "$output"
