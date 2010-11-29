# $Id$
.PHONY:FORCE

SHELL=/bin/sh
SHARE = /usr/share/emacs
SITELISP = $(SHARE)/site-lisp

EMACS=$(EMACSPATH)/emacs

BOOTSTRAP_SOURCES=config.el
XZ=xz
ETAGS=etags
TOP := $(shell pwd)

all:

compile:
	$(EMACS) --batch -l byte-compile-directory.el

.PHONY: compile


ship: FORCE
	install -m 444 $(BOOTSTRAP_SOURCES) $(SITELISP)