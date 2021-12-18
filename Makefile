.EXPORT_ALL_VARIABLES:

.DEFAULT_GOAL = help

# ANSI codes
BOLD=[1m
DIM=[2m
ITALIC=[3m
RESET=[0m

VENV     := .venv
PATH     := $(VENV)/bin:$(PATH)
SUBMAKE  := $(MAKE) --no-print-directory
LINT_OUT := lint.tmp

define sh
@ printf "\e$(DIM)$$ %s\e$(RESET)\n" \
	"$$(echo $1 | sed -E 's,make -[^ ]+ ,make ,')" && \
	SILENT=true $1;
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

.PHONY: wtf
wtf:
	@ test/lint/wtf.sh || true

.PHONY: lintspaces
lintspaces:
	@ test/lint/lintspaces.sh || true

.PHONY: ec
ec:
	@ test/lint/ec.sh || true

.PHONY: cspell
cspell:
	@ test/lint/cspell.sh || true

.PHONY: markdownlint
markdownlint:
	@ test/lint/markdownlint.sh || true

.PHONY: prettier
prettier:
	@ test/lint/prettier.sh || true

.PHONY: shellcheck
shellcheck:
	@ test/lint/shellcheck.sh || true

.PHONY: shfmt
shfmt:
	@ test/lint/shfmt.sh || true

.PHONY: prospector
prospector: $(VENV)
	@ test/lint/prospector.sh || true

.PHONY: flake8
flake8: $(VENV)
	@ test/lint/flake8.sh || true

.PHONY: pytest
pytest: $(VENV)
	@ test/lint/pytest.sh || true

.PHONY: codecov
codecov: $(VENV)
	@ test/lint/codecov.sh || true

.PHONY: lint-clean
lint-clean:
	@ rm -f $(LINT_OUT)

.PHONY: lint-output
lint-run: $(VENV) lint-clean
	$(call sh,$(SUBMAKE) wtf)
	$(call sh,$(SUBMAKE) lintspaces)
	$(call sh,$(SUBMAKE) ec)
	$(call sh,$(SUBMAKE) cspell)
	$(call sh,$(SUBMAKE) markdownlint)
	$(call sh,$(SUBMAKE) prettier)
	$(call sh,$(SUBMAKE) shellcheck)
	$(call sh,$(SUBMAKE) shfmt)
	$(call sh,$(SUBMAKE) prospector)
	$(call sh,$(SUBMAKE) flake8)
	$(call sh,$(SUBMAKE) pytest)
	$(call sh,$(SUBMAKE) codecov)

.PHONY: lint-format
lint-process:
	@ if test -s "$(LINT_OUT)"; then \
		obelist format --error-on="notice" "$(LINT_OUT)"; \
	fi

.PHONY: lint # Run lint checks
lint: lint-run lint-process

# TODO: Not implemented yet
.PHONY: format # Run all available auto-formatters
format:
	@ echo shellcheck --format=diff
	@ echo black

.PHONY: clean # Reset the build cache
clean: install-clean
