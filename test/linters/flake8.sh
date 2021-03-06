#!/bin/sh -e

. test/lib/setup/linter.sh

# TODO: Add more flake8 extensions
# https://github.com/DmytroLitvinov/awesome-flake8-extensions
# https://lyz-code.github.io/blue-book/devops/flakehell/
# https://codeclimate.com/github/best-doctor/flake8-annotations-complexity
# https://www.giters.com/justinludwig/flake8-expression-complexity
# https://radon.readthedocs.io/en/latest/flake8.html

# Using a pipe means the exit value of the first command will be ignored,
# allowing `obelist` to determine which severity level should result in an
# error
flake8 . |
    obelist parse --quiet --console --write "${lint_out}" \
        --error-on="notice" --parser "flake8" --format "txt" -
