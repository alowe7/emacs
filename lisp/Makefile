# $Id$
.PHONY:FORCE

SHELL=/bin/sh

ifneq ($(strip $(EMACSPATH)),)
EMACS := $(EMACSPATH)/emacs
else
EMACS := $(shell which emacs  2> /dev/null)
endif

TARGETS:=*.el

all:

clean: FORCE
	rm -f $(AUTOLOADS) *.elc .xz.dat

compile: clean
ifeq ($(strip $(EMACS)),)
	@echo "EMACS not found"
else
	$(EMACS) --batch -l byte-compile-directory.el -e batch-byte-compile $(TARGETS)
endif

