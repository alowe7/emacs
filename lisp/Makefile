# $Id: Makefile,v 1.7 2006-02-13 15:32:30 alowe Exp $
.PHONY:FORCE

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
