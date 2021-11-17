# Copyright 2021, Naomi Rose and contributors
#
# Copying and distribution of this file, with or without modification, are
# permitted in any medium without royalty, provided the copyright notice and
# this notice are preserved. This file is offered as-is, without any warranty.

# https://git.io/JKEJL
FROM ghcr.io/bottle-garden/devcontainer:main

USER root
WORKDIR /tmp

COPY * /tmp/

RUN make clean && make install
