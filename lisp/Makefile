# $Id: Makefile,v 1.4 2001-10-25 22:27:20 cvs Exp $

SHELL=/bin/sh
EMACS=$(EMACS_DIR)/bin/emacs

#SOURCES=$(shell -c ls -t *.el)
SOURCES=*.el
XZ=xz
ETAGS=etags

all: 

.xz.dat: $(SOURCES)
	$(XZ) -ywqn $(SOURCES)

TAGS: $(SOURCES)
	$(ETAGS) $(SOURCES)

compile:
	$(EMACS) --batch -l byte-compile-directory

.PHONY: compile
