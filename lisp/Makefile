# $Id$
.PHONY:FORCE

SHELL=/bin/sh
EMACS=$(EMACSPATH)/emacs
TARGETS:=*.el

all:

clean: FORCE
	rm -f $(AUTOLOADS) *.elc .xz.dat

compile: clean
	$(EMACS) --batch -l byte-compile-directory.el -e batch-byte-compile $(TARGETS)

