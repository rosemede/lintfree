# TODO: Not happy about this having to live inside `.devcontainer`
include .devcontainer/common.mk

VENV    := .venv
PATH    := $(VENV)/bin:$(PATH)
SUBMAKE := $(MAKE) --no-print-directory

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

LINT_DEPS += shellcheck
.PHONY: shellcheck
shellcheck: $(VENV)
	$(call sh,test/lint/shellcheck.sh)

lint: $(VENV)
	@ $(SUBMAKE) shellcheck || touch $@.tmp
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
