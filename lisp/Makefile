# $Id$
.PHONY:FORCE

SHELL=/bin/sh
#EMACS=$(EMACS_DIR)/bin/emacs
EMACS=$(shell which emacs)
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

.xz.dat: $(SOURCES)
	$(XZ) -ywqn $(SOURCES)

TAGS: $(SOURCES)
	$(ETAGS) $(SOURCES)

compile:
	$(EMACS) --batch -l byte-compile-directory.el

.PHONY: compile
