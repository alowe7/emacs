# $Id: Makefile,v 1.6 2005-12-16 00:31:47 tombstone Exp $

SHELL=/bin/sh
#EMACS=$(EMACS_DIR)/bin/emacs
EMACS=$(shell which emacs)

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
	$(EMACS) --batch -l byte-compile-directory.el

.PHONY: compile
