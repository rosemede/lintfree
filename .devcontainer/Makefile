# Copyright 2021, Naomi Rose and contributors
#
# Copying and distribution of this file, with or without modification, are
# permitted in any medium without royalty, provided the copyright notice and
# this notice are preserved. This file is offered as-is, without any warranty.

include common.mk

Brewfile.lock.json: Brewfile
	$(call sh,brew bundle --file $<)

brew: Brewfile.lock.json

brew-clean:
	$(call sh,rm -f Brewfile.lock.json)

pipx.lock.txt: pipx.txt
	$(call sh,pipx upgrade pipx)
	$(call sh,cat $< | xargs pipx install --force)
	$(call sh,pipx list > $@)

pipx: brew
pipx: pipx.lock.txt

pipx-clean:
	$(call sh,rm -f pipx.lock.txt)

package-lock.json: pipx
package-lock.json: package.json
	$(call sh,npm install --global npm@latest)
	$(call sh,npm install --global --prefer-dedupe)
	$(call sh,npm install --package-lock-only > /dev/null)

npm: package-lock.json

npm-clean:
	$(call sh,rm -f package-lock.json)

install.stamp: npm
	$(call sh,touch $@)

.PHONY: install # Install the necessary software packages
install: install.stamp

install-clean:
	$(call sh,rm -f install.stamp)

.PHONY: clean # Reset the Make cache
clean: brew-clean pipx-clean npm-clean install-clean
