.EXPORT_ALL_VARIABLES:

.DEFAULT_GOAL = help

# ANSI codes
BOLD=[1m
DIM=[2m
ITALIC=[3m
RESET=[0m

VENV    := .venv
PATH    := $(VENV)/bin:$(PATH)
SUBMAKE := $(MAKE) --no-print-directory

define sh
@ if test "${GITHUB_ACTIONS}" = "true"; then \
	echo "::group::$$ $1" && $1 || (echo "::endgroup::" && false); \
else \
	printf "\e$(DIM)$$ %s\e$(RESET)\n" \
		"$$(echo $1 | sed -E 's,make -[^ ]+ ,make ,')" && $1; \
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

$(VENV):
	$(call sh,poetry install)
	@ $(SUBMAKE) venv-help

.PHONY: venv-help
venv-help:
	@ if test -z "${VIRTUAL_ENV}"; then \
		echo; \
		printf "Run \`\e[4mpoetry shell\e[0m\` to activate your "; \
		printf "Python virtual environment\n"; \
	fi

.PHONY: install # Install the Python package into a virtual environment
install: $(VENV)

install-clean:
	$(call sh,rm -rf $(VENV))

update-run:
	$(call sh,poetry update)

.PHONY: update # Update the Python package and reinstall
update: install-clean update-run install
	@ $(SUBMAKE) venv-help

.PHONY: ec
ec: $(VENV)
	@ test/lint/ec.sh || touch $@.tmp

.PHONY: shellcheck
shellcheck: $(VENV)
	@ test/lint/shellcheck.sh || touch $@.tmp

lint: $(VENV)
	$(call sh,$(SUBMAKE) ec)
	$(call sh,$(SUBMAKE) shellcheck)
	@ if test -e $@.tmp; then \
		rm -f $@.tmp; \
		exit 1; \
	fi

# TODO: Not implemented yet
.PHONY: format # Run all available auto-formatters
format:
	@ echo shellcheck --format=diff
	@ echo black

.PHONY: clean # Reset the build cache
clean: install-clean
