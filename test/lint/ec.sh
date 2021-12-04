#!/bin/sh -e

rerun_parse() {
    ec -no-color | octonote parse --quiet --parser ec --format txt -
}

"${
ec >/dev/null || rerun_parse
