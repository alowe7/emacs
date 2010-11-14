# $Id$
.PHONY:FORCE

SHELL=/bin/sh

EMACS=$(EMACSPATH)/emacs

MAKE_AUTOLOADS=$(shell which make-autoloads)

#SOURCES=$(shell -c ls -t *.el)
SOURCES=*.el
XZ=xz
ETAGS=etags
TOP := $(shell pwd)

all: .autoloads

.autoloads: FORCE $(SOURCES) 
	$(MAKE_AUTOLOADS) --top $(TOP) $^ > .autoloads
	@echo .autoloads rebuilt

TAGS: $(SOURCES)
	$(ETAGS) $(SOURCES)

compile:
	$(EMACS) --batch -l byte-compile-directory.el

.PHONY: compile
