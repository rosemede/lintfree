.EXPORT_ALL_VARIABLES:

.DEFAULT_GOAL = help

# ANSI codes
BOLD=[1m
DIM=[2m
ITALIC=[3m
RESET=[0m

VENV     := .venv
PATH     := $(VENV)/bin:$(PATH)
LOCK     := poetry.lock
DIST     := dist
TOX      := .tox
SUBMAKE  := $(MAKE) --no-print-directory
LINT_OUT := lint.tmp

define sh
printf "\e$(DIM)$$ %s\e$(RESET)\n" \
	"$$(echo $1 | sed -E 's,make -[^ ]+ ,make ,')" && \
	OBELIST_NO_ERROR="true" $1
endef

define lint-target
printf "\e$(DIM)$$ make $*\e$(RESET)\n" && test/linters/$*.sh
endef

.PHONY: help # Print this help message and exit
help:
	@ printf "\e$(BOLD)Targets:\e$(RESET)\n\n"
	@ @grep -E '^.PHONY:' Makefile | \
		grep "#" | sed 's,.*: ,,' | \
		awk 'BEGIN {FS = " # "}; {printf "  make %s/%s\n", $$1, $$2}' | \
		column -t -s '/' | \
		sed -E 's,(.*make )([^ ]+)( .*),\1\x1b$(ITALIC)\2\x1b$(RESET)\3,'

$(VENV):
	@ $(call sh,poetry install)
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

.PHONY: install-reset
install-reset:
	@ rm -rf $(VENV)
	@ rm -rf $(LOCK)

update-run:
	@ $(call sh,poetry update)

.PHONY: update # Update the Python package and reinstall
update: install-reset update-run install
	@ $(SUBMAKE) venv-help

$(DIST):
	@ $(call sh,poetry build)

.PHONY: build # Build the Python package
build: $(DIST)

.PHONY: build-reset
build-reset:
	@ rm -rf $(DIST)

.PHONY: lint-%
lint-%: install
	@ $(call lint-target)

# TODO: Parallelize these commands (using Make's inbuilt features, or do it
# manually
.PHONY: lint-output
lint-run: install lint-reset
	@ $(SUBMAKE) lint-targets | while read -r target; do \
		$(SUBMAKE) "lint-$$target"; \
	done

.PHONY: lint-format
lint-process: lint-run
	@ if test -s "$(LINT_OUT)"; then \
		obelist format --error-on="notice" "$(LINT_OUT)"; \
	fi

.PHONY: lint # Lint the source code
lint: lint-process
	@ $(SUBMAKE) lint-reset

.PHONY: lint
lint-targets:
	@ find test/linters -type f | sed -E 's,^.*/(.*)\.sh$$,\1,' | sort -n

.PHONY: lint-reset
lint-reset:
	@ rm -f $(LINT_OUT)

.PHONY: test-%
test-%:
	@ $(call sh,poetry run tox -e $*)

.PHONY: test # Build and test the Python package
test: install build
	@ $(SUBMAKE) test-targets | while read -r target; do \
		$(SUBMAKE) "test-$$target"; \
	done

.PHONY: tests-targets
test-targets:
	@ poetry run tox --listenvs | sort -n

.PHONY: tests-reset
test-reset:
	@ rm -rf $(TOX)

.PHONY: checks # Lint, build, and test the Python package
checks:
	@ $(SUBMAKE) lint
	@ $(SUBMAKE) test

# TODO: Not implemented yet
.PHONY: format # Run auto-formatters
format:
	@ echo shellcheck --format=diff
	@ echo black

.PHONY: reset # Reset the build cache
reset: install-reset lint-reset build-reset test-reset
