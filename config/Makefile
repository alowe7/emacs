# $Id: Makefile 952 2011-02-04 23:31:21Z alowe $
.PHONY:FORCE

SHELL=/bin/sh

ifneq ($(strip $(EMACSPATH)),)
EMACS := $(EMACSPATH)/emacs
else
EMACS := $(shell which emacs  2> /dev/null)
endif

all:

clean: FORCE
	find . -name "*.elc" -exec rm {} \;

compile: clean
ifeq ($(strip $(EMACS)),)
	@echo "EMACS not found"
else
	$(EMACS) --batch -l byte-compile-configs.el
endif

