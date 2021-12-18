#!/bin/sh -e

. test/lib/setup/linter.sh

# Using a pipe means the exit value of the first command will be ignored,
# allowing `obelist` to determine which severity level should result in an
# error
ec -no-color |
    obelist parse --quiet --console --write "${lint_out}" \
        --error-on="notice" --parser "ec" --format "txt" -
