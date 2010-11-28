# $Id$
.PHONY:FORCE

SHELL=/bin/sh

EMACS=$(EMACSPATH)/emacs

#SOURCES=$(shell -c ls -t *.el)
SOURCES=*.el
XZ=xz
ETAGS=etags
TOP := $(shell pwd)

all:

TAGS: $(SOURCES)
	$(ETAGS) $(SOURCES)

compile:
	$(EMACS) --batch -l byte-compile-directory.el

.PHONY: compile
