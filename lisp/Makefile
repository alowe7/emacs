# $Id: Makefile,v 1.5 2005-01-28 19:37:47 cvs Exp $

SHELL=/bin/sh
EMACS=$(EMACS_DIR)/bin/emacs

#SOURCES=$(shell -c ls -t *.el)
SOURCES=*.el
XZ=xz
ETAGS=etags
TOP := $(shell pwd)

all: .autoloads

.autoloads: FORCE $(SOURCES) 
	./make-autoloads --top $(TOP) $^ > .autoloads
	@echo .autoloads rebuilt

.xz.dat: $(SOURCES)
	$(XZ) -ywqn $(SOURCES)

TAGS: $(SOURCES)
	$(ETAGS) $(SOURCES)

compile:
	$(EMACS) --batch -l byte-compile-directory

.PHONY: compile
