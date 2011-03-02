# $Id: Makefile 952 2011-02-04 23:31:21Z alowe $
.PHONY:FORCE

SHELL=/bin/sh

# only search for relevant configs -- use perl hostname to ensure portability
CONFIGS := $(shell ../find-configs)
TARGETS := $(CONFIGS:.el=.elc)

ifneq ($(strip $(EMACSPATH)),)
EMACS := $(EMACSPATH)/emacs
else
EMACS := $(shell which emacs  2> /dev/null)
endif

all: $(TARGETS)

clean: FORCE
	find . -name "*.elc" -exec rm {} \;

compile: 
ifeq ($(strip $(EMACS)),)
	@echo "EMACS not found"
else
	$(EMACS) --batch -l byte-compile-configs.el -e batch-byte-compile-if-not-done $(CONFIGS)
endif

%.elc : %.el
ifeq ($(strip $(EMACS)),)
	@echo "EMACS not found"
else
	$(EMACS) --batch -l byte-compile-configs.el -e batch-byte-compile-if-not-done $<
endif
