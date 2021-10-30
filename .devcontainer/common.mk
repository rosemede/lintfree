.EXPORT_ALL_VARIABLES:

.DEFAULT_GOAL = help

# ANSI codes
BOLD=[1m
DIM=[2m
ITALIC=[3m
RESET=[0m


define sh
@ if test "${GITHUB_ACTIONS}" = "true"; then \
	echo "::group::$$ $1" && $1 || (echo "::endgroup::" && false); \
else \
	printf "\e$(DIM)$$ %s\e$(RESET)\n" "$1" && $1; \
fi
endef

.PHONY: help # Print this help message and exit
help:
	@ printf "\e$(BOLD)Targets:\e$(RESET)\n\n"
	@ @grep -E '^.PHONY:' $(shell printf "%s\n" $(MAKEFILE_LIST) | tac) | \
		grep "#" | sed 's,.*: ,,' | \
		awk 'BEGIN {FS = " # "}; {printf "  make %s,%s\n", $$1, $$2}' | \
		column -t -s ',' | \
		sed -E 's,(.*make )([^ ]+)( .*),\1\x1b$(ITALIC)\2\x1b$(RESET)\3,'
