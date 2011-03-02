# $Id$
.PHONY:FORCE

SHELL=/bin/sh

ifneq ($(strip $(EMACSPATH)),)
EMACS := $(EMACSPATH)/emacs
else
EMACS := $(shell which emacs  2> /dev/null)
endif

SOURCES:=$(wildcard *.el)
TARGETS := $(SOURCES:.el=.elc)

all: $(TARGETS)

clean: FORCE
	rm -f $(AUTOLOADS) *.elc .xz.dat

compile: 
ifeq ($(strip $(EMACS)),)
	@echo "EMACS not found"
else
	$(EMACS) --batch -l byte-compile-directory.el -e batch-byte-compile-if-not-done $(SOURCES)
endif

%.elc : %.el
ifeq ($(strip $(EMACS)),)
	@echo "EMACS not found"
else
	$(EMACS) --batch -l  byte-compile-directory.el -e batch-byte-compile-if-not-done $<
endif
