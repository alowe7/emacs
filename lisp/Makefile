# $Id$
.PHONY:FORCE

SHELL=/bin/sh
EMACS=$(EMACSPATH)/emacs

all:

compile:
	$(EMACS) --batch -l byte-compile-directory.el -e batch-byte-compile $^

